class BookingsController < ApplicationController

  skip_before_action :verify_authenticity_token, :only => :update

  def create
    session = Session.find(params[:session])
    @workshop = session.workshop
    if params[:booking].present? && params[:booking][:status].present? && params[:booking][:status] == "interdit"
      @booking = Booking.new
      authorize @booking
      flash[:alert] = "Vous ne pouvez pas réserver d'atelier avec votre compte partenaire. Déconnectez-vous et créez un compte particulier ;)"
      redirect_to workshop_path(@workshop)
    else
      quantity = params[:quantity].to_i
      @booking = Booking.create!(
        status: 'pending',
        quantity: quantity,
        amount: quantity * @workshop.price,
        workshop_unit_price: @workshop.price,
        session: session,
        user: current_user,
        fee: @workshop.place.user.profile.fee
        )
      authorize @booking
      CheckBookingStatusJob.set(wait: 20.minutes).perform_later(@booking)
      redirect_to booking_coordonnees_path(@booking)
    end
  end

  def update
    @booking = Booking.find(params[:id])
    authorize @booking

    if booking_params.include?(:confirm_giftcard)
      @giftcard = Giftcard.find(@booking.giftcard_id.to_i)
      new_amount = @giftcard.amount - @booking.giftcard_amount_spent
      @giftcard.update(amount: new_amount)
      @booking.update(status: "paid")

      key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
      Stripe.api_key = key

      charge = Stripe::PaymentIntent.retrieve(@giftcard.payment_intent_id).charges.first

      transfer = Stripe::Transfer.create({
        amount: ((@booking.giftcard_amount_spent - (@booking.giftcard_amount_spent * @booking.fee)) * 100).to_i,
        currency: 'eur',
        transfer_group: "GIFTCARD_#{@giftcard.id}",
        source_transaction: charge.id,
        destination: @booking.session.workshop.place.user.stripe_uid,
      })

      @giftcard.stripe_transfers << "#{transfer.id},"
      @giftcard.save

      @booking.update(stripe_giftcard_transfer: transfer.id)

      redirect_to booking_payment_success_url(@booking)

    else
      @booking.update(booking_params)
      if @booking.giftcard_id.present? && @booking.giftcard_amount_spent.nil?
        giftcard = Giftcard.all.find(@booking.giftcard_id.to_i)
        if giftcard.amount >= @booking.amount
          @booking.update(giftcard_amount_spent: @booking.amount)
        else
          @booking.update(giftcard_amount_spent: giftcard.amount)
        end
      end
      if params[:booking][:kit_expedition_status].present? && params[:booking][:kit_expedition_status] == "Expédiée"
        mail_expedition = BookingMailer.with(booking: @booking).kit_expedition_notification
        mail_expedition.deliver_later(wait: 3.hours)
      end
      if params[:booking][:cgv_agreement].present?
        if (@booking.session.workshop.visio_with_kit? && @booking.contact_visio_completed?) || ((@booking.session.workshop.kit == false ) && @booking.contact_completed?)
          redirect_to new_booking_payment_path(@booking)
        end
      else
        redirect_back fallback_location: root_path
      end
    end
  end

  def coordonnees
    @booking = Booking.find(params[:booking_id])
    authorize @booking
    if params[:booking]
      @booking.update(booking_params)
      if (@booking.session.workshop.visio_with_kit? && @booking.contact_visio_completed?) || ((@booking.session.workshop.kit == false) && @booking.contact_completed?)
        redirect_to booking_options_path(@booking)
      else
        flash[:alert] = "Vos coordonnées sont incomplètes."
        redirect_back fallback_location: root_path
      end
    end
  end

  def options
    @booking = Booking.find(params[:booking_id])
    @booking.update(cgv_agreement: false)
    authorize @booking
    @my_giftcards = current_user.giftcards.select { |giftcard| giftcard.buyer != current_user.id && giftcard.amount.to_i > 0 && giftcard.deadline_date >= Date.today && giftcard.status == "paid" && giftcard.db_status == true }
  end

  def show
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def payment_success
    @booking = Booking.find(params[:booking_id])
    authorize @booking
    @partner = @booking.session.workshop.place.user.profile
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "facture-jdm-#{@booking.created_at.strftime("%Y%m")}#{@booking.id}",
              margin:  { top:0,bottom:0,left:0,right:0}
      end
    end
  end
  def payment_error
    @booking = Booking.find(params[:booking_id])
    authorize @booking
  end

  def refund_invoice
    @booking = Booking.find(params[:booking_id])
    authorize @booking
    @partner = @booking.session.workshop.place.user.profile
    respond_to do |format|
      format.pdf do
        render pdf: "avoir-jdm-#{@booking.created_at.strftime("%Y%m")}#{@booking.id}",
              margin:  { top:0,bottom:0,left:0,right:0}
      end
    end
  end

  def cancel
    if params[:booking_id].present?
      @booking = Booking.find(params[:booking_id])
    elsif params[:cancel][:booking_id].present?
      @booking = Booking.find(params[:cancel][:booking_id])
    end
    authorize @booking
    booking_start_time = Time.new(@booking.session.date.strftime('%Y').to_i, @booking.session.date.strftime('%m').to_i, @booking.session.date.strftime('%d').to_i, @booking.session.start_at[0..1], @booking.session.start_at[-2..-1], 0, "+01:00")
    cancel_time = Time.now

    if @booking.session.reason.present? && @booking.session.db_status == false
      @booking.refund_rate = 1.0
    else
      if (0..3.99).include?((booking_start_time - cancel_time) / 1.hours)
        @booking.refund_rate = 0.0
      elsif (4..47.99).include?((booking_start_time - cancel_time) / 1.hours) && @booking.session.workshop.kit == false
        @booking.refund_rate = 0.5
      elsif (4..167.99).include?((booking_start_time - cancel_time) / 1.hours) && @booking.session.workshop.kit == true
        @booking.refund_rate = 0.5
      else
        @booking.refund_rate = 1.0
      end
    end

    key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
    Stripe.api_key = key

    # Retrouver si paiement que en carte bancaire ou CC + CB ou CC uniquement
    # Prévoir aussi règles de J-2 avant événement, 50% remboursés etc

    if @booking.giftcard_id.present?

      # CAS UTILISATION DE CC UNIQUEMENT LORS DE LA RESERVATION INITIALE

      if @booking.amount == @booking.giftcard_amount_spent

      # ETAPE 1
      # JDM reprend à l'organisateur le montant de la carte cadeau utilisé sans la commission.

        Stripe::Transfer.create_reversal(@booking.stripe_giftcard_transfer,
          {amount: ((@booking.giftcard_amount_spent * @booking.refund_rate * (1.0 - @booking.fee)) * 100).to_i},
        )

      # ETAPE 2
      # JDM réinjecte l'argent de la CC dans la CC et si CC expirée, ajout de 1 mois.

        giftcard = Giftcard.find(@booking.giftcard_id.to_i)

          # carte cadeau périmée, ajout de un mois de validité + montant.
        if giftcard.deadline_date < Date.today
          giftcard.amount += (@booking.giftcard_amount_spent * @booking.refund_rate)
          giftcard.deadline_date = Date.today + 1.month
          giftcard.save
        else
          giftcard.amount += (@booking.giftcard_amount_spent * @booking.refund_rate)
          giftcard.save
        end

        SendCancelBookingEmailsJob.perform_now(@booking)

        @booking.update(status: "refunded", cancelled_at: Time.now)

      else

      # CAS UTILISATION DE CC + CB LORS DE LA RESERVATION INITIALE

      # ETAPE 1
      # Si carte cadeau, JDM rembourse le client de ce qu'il avait payé avec sa CB.
      # Et JDM reprend ce même montant à l'organisateur sans la commission.

        bank_refund = Stripe::Refund.create({
          payment_intent: @booking.payment_intent_id,
          amount: ((@booking.amount - @booking.giftcard_amount_spent) * @booking.refund_rate * 100).to_i,
          refund_application_fee: true,
          reverse_transfer: true,
        })

        @booking.update(refund_id: bank_refund.id, charge_id: bank_refund.charge)
        @booking.save

        # ETAPES 2 & 3 remboursement carte cadeau restant et remboursement entre JDM et orga que si l'étape 1 a fonctionné par Stripe, voir ensuite Services > refund service
      end


    else

      # CAS UTILISATION DE LA CB UNIQUEMENT LORS DE LA RESERVATION INITIALE

      refund = Stripe::Refund.create({
        payment_intent: @booking.payment_intent_id,
        amount: (@booking.amount * @booking.refund_rate * 100).to_i,
        refund_application_fee: true,
        reverse_transfer: true,
      })

      @booking.update(refund_id: refund.id, charge_id: refund.charge)
      @booking.save

    end

    flash[:notice] = "Votre réservation a bien été annulée, vous avez reçu un e-mail."
    redirect_back fallback_location: root_path
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.update(db_status: false)
    @booking.save
    redirect_back fallback_location: root_path
  end

  private

  def booking_params
    params.require(:booking).permit(:quantity, :status, :amount, :user_id, :session_id, :db_status, :checkout_session_id, :payment_intent_id, :charge_id, :refund_id, :cgv_agreement, :giftcard_id, :giftcard_amount_spent, :cancelled_at, :stripe_giftcard_transfer, :confirm_giftcard, :phone_number, :address, :address_complement, :zip_code, :city, :kit_expedition_status, :kit_expedition_link, :refund_rate, :workshop_unit_price, :fee)
  end

end
