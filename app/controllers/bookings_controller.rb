class BookingsController < ApplicationController

  skip_before_action :verify_authenticity_token, :only => :update

  def create
    session = Session.find(params[:session])
    workshop = session.workshop
    quantity = params[:quantity].to_i
    @booking = Booking.create!(
      status: 'pending',
      quantity: quantity,
      amount: quantity * workshop.price,
      session: session,
      user: current_user
      )
    authorize @booking

    redirect_to booking_options_path(@booking)
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
        amount: ((@booking.giftcard_amount_spent - (@booking.giftcard_amount_spent * 0.2)) * 100).to_i,
        currency: 'eur',
        transfer_group: "GIFTCARD_#{@giftcard.id}",
        source_transaction: charge.id,
        destination: @booking.session.workshop.place.user.stripe_uid,
      })

      @giftcard.stripe_transfers << "#{transfer.id},"
      @giftcard.save

      @booking.update(stripe_giftcard_transfer: transfer.id)


      redirect_to tableau_de_bord_profile_path(current_user.profile)

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
      redirect_back fallback_location: root_path
    end
  end

  def options
    @booking = Booking.find(params[:booking_id])
    authorize @booking
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking

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
          {amount: ((@booking.giftcard_amount_spent * 0.8) * 100).to_i},
        )

      # ETAPE 2
      # JDM réinjecte l'argent de la CC dans la CC et si CC expirée, ajout de 1 mois.

        giftcard = Giftcard.find(@booking.giftcard_id.to_i)

          # carte cadeau périmée, ajout de un mois de validité + montant.
        if giftcard.deadline_date < Date.today
          giftcard.amount += @booking.giftcard_amount_spent
          giftcard.deadline_date += 1.month
          giftcard.save
        else
          giftcard.amount += @booking.giftcard_amount_spent
          giftcard.save
        end

        SendCancelBookingEmailsJob.perform_now(@booking)

        @booking.update(db_status: false, status: "refunded")

      else

      # CAS UTILISATION DE CC + CB LORS DE LA RESERVATION INITIALE

      # ETAPE 1
      # Si carte cadeau, JDM rembourse le client de ce qu'il avait payé avec sa CB.
      # Et JDM reprend ce même montant à l'organisateur sans la commission.

        bank_refund = Stripe::Refund.create({
          payment_intent: @booking.payment_intent_id,
          amount: ((@booking.amount - @booking.giftcard_amount_spent) * 100).to_i,
          refund_application_fee: true,
          reverse_transfer: true,
        })

        @booking.update(refund_id: bank_refund.id, charge_id: bank_refund.charge, db_status: false)
        @booking.save

        # ETAPES 2 & 3 remboursement carte cadeau restant et remboursement entre JDM et orga que si l'étape 1 a fonctionné par Stripe, voir ensuite Services > refund service
      end


    else

      # CAS UTILISATION DE LA CB UNIQUEMENT LORS DE LA RESERVATION INITIALE

      refund = Stripe::Refund.create({
        payment_intent: @booking.payment_intent_id,
        amount: (@booking.amount * 100).to_i,
        refund_application_fee: true,
        reverse_transfer: true,
      })

      @booking.update(refund_id: refund.id, charge_id: refund.charge, db_status: false)
      @booking.save

    end

    redirect_back fallback_location: root_path
  end

  private

  def booking_params
    params.require(:booking).permit(:quantity, :status, :amount, :user_id, :session_id, :db_status, :checkout_session_id, :payment_intent_id, :charge_id, :refund_id, :cgv_agreement, :giftcard_id, :giftcard_amount_spent, :cancelled_at, :stripe_giftcard_transfer, :confirm_giftcard)
  end

end
