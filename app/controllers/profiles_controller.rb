class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(public)
  before_action :set_profile, only: %i(edit update messagerie send_finalisation_partner_email)
  before_action :set_profile_and_verify, only: %i(show tableau_de_bord transactions)

  def index
    @profile = current_user.profile
    authorize @profile
    @chatroom = Chatroom.new
    @profiles = policy_scope(Profile).where(db_status: true, ready: true).select { |profile| profile.role.present? }
    if params[:search].present?
      @profiles = @profiles.select { |profile| profile.company.include?(params[:search][:company])} if params[:search][:company].present? && params[:search][:company].include?("Tous les partenaires") == false
      @profiles = @profiles.select { |profile| profile.role.include?(params[:search][:role])} if params[:search][:role].present? && params[:search][:role].include?("Tous profils") == false
      @profiles = @profiles.select { |profile| profile.thematics.include?(params[:search][:keyword])} if params[:search][:keyword].present? && params[:search][:keyword].include?("Toutes thématiques") == false
      @profiles = @profiles.select { |profile| profile.district == params[:search][:place] || profile.big_city == params[:search][:place] } if params[:search][:place].present? && params[:search][:place].include?("Toutes les villes") == false
    end
  end

  def show
  end

  def edit
  end

  def update
    @profile.update(profile_params)
    if @profile.role.present?
      if (@profile.user.places.present? && @profile.user.places.where(name: "Atelier en visio").count == 0) || @profile.user.places.nil?
        @place = Place.new(name: "Atelier en visio", address: "Visio", zip_code: "Visio", city: "Visio")
        @place.user = @profile.user
        @place.save
      end
    end
    if @profile.save
      flash[:notice] = "Vos modifications ont bien été prises en compte."
      redirect_to profile_path(@profile)
    else
      redirect_to profile_path(@profile)
    end
  end

  def mes_cartes_cadeaux
    if Profile.friendly.find(params[:id]).db_status == true && Profile.friendly.find(params[:id]).role.present? == false
      @profile = Profile.friendly.find(params[:id])
      authorize @profile
      @my_received_giftcards = @profile.user.giftcards.select { |giftcard| giftcard.buyer != current_user.id && giftcard.status == "paid" && giftcard.db_status == true}
      @my_offered_giftcards = policy_scope(Giftcard).all.select { |giftcard| giftcard.buyer == current_user.id && giftcard.status == "paid" && giftcard.db_status == true }
    end
  end

  def transactions
    @transaction_bookings = []
    Booking.all.where(db_status: true).select { |b| b.status == "paid" || b.status == "refunded"}.select { |b| b.session.workshop.place.user.profile == @profile }.each do |b|
      if b.status == "refunded"
        @b_refund = {
          booking: b,
          date: b.cancelled_at.to_date,
          label: "Paiement remboursé à #{(b.refund_rate * 100).round}%",
          workshop: b.session.workshop,
          session: b.session,
          booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
          amount: b.amount,
          fee_rate: b.fee,
          refund_rate: b.refund_rate,
          status: "refunded"
        }
        @transaction_bookings << @b_refund
      end
      @b_success = {
        booking: b,
        date: b.created_at.to_date,
        label: "Paiement réussi",
        workshop: b.session.workshop,
        session: b.session,
        booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
        amount: b.amount,
        fee_rate: b.fee,
        status: "success"
      }
      @transaction_bookings << @b_success
    end
    @transaction_bookings.sort_by { |b| b[:date] }

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def tableau_de_bord
    @users = User.all.where(db_status: true).select { |user| user.profile.role.present? && user.profile.ready == true && user != current_user }
    @animator = Animator.new
    @session = Session.new
    @workshop = Workshop.new
    @chatroom = Chatroom.new
  end

  def messagerie
    @user_chatrooms = []
    Chatroom.all.each do |chatroom|
      if User.find(chatroom.user1) == current_user || User.find(chatroom.user2) == current_user
        @user_chatrooms << chatroom
      end
    end
    @user_chatrooms
  end

  def public
    if Profile.friendly.find(params[:profile_id]).db_status == true
      @profile = Profile.friendly.find(params[:profile_id])
      authorize @profile
      dates = (Date.today..Date.today + 2.year).to_a
      @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
    end
  end

  def send_finalisation_partner_email
    mail = PartnerMailer.with(profile: @profile).send_finalisation_email
    mail.deliver_later
    flash[:notice] = "L'e-mail a bien été envoyé !"
    redirect_back fallback_location: root_path
  end

  def comptabilite_reservations
    if Profile.friendly.find(params[:id]).user.admin == true && current_user.admin == true
      @profile = Profile.friendly.find(params[:id])
      authorize @profile
      key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
      Stripe.api_key = key
      @fees = []
      Booking.all.select { |b| b.payment_intent_id.present? }.each do |b|
        payment = Stripe::PaymentIntent.retrieve(b.payment_intent_id)
        if payment[:status] == "succeeded"
          fee = Stripe::ApplicationFee.retrieve(payment[:charges][:data][0][:application_fee])
          @fee = {
            id: fee[:id],
            amount: fee[:amount],
            payment_intent: b.payment_intent_id,
            booking_id: b.id,
            created: fee[:created],
            currency: fee[:currency],
            type: 'reçu'
          }
          if fee[:refunded] == true
            fee_refund = Stripe::ApplicationFee.retrieve_refund(payment[:charges][:data][0][:application_fee], fee[:refunds][:data][0][:id])
            @fee_refund = {
              id: fee[:id],
              amount: fee_refund[:amount],
              payment_intent: b.payment_intent_id,
              booking_id: b.id,
              created: fee_refund[:created],
              currency: fee_refund[:currency],
              type: 'remboursé'
            }
          end
        end
        @fees << @fee if @fee
        @fees << @fee_refund if @fee_refund
      end
      @fees
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def comptabilite_cartes_cadeaux
    if Profile.friendly.find(params[:id]).user.admin == true && current_user.admin == true
      @profile = Profile.friendly.find(params[:id])
      authorize @profile
      key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
      Stripe.api_key = key
      @charges = []
      Giftcard.all.select { |g| g.payment_intent_id.present? }.each do |g|
        payment = Stripe::PaymentIntent.retrieve(g.payment_intent_id)
        charge = Stripe::Charge.retrieve(payment[:charges][:data][0][:id])
        if charge[:status] == "succeeded" && charge[:destination].nil?
          @charge = {
            id: charge[:id],
            charge_id: charge[:id],
            payment_intent: g.payment_intent_id,
            amount: charge[:amount],
            giftcard_id: g.id,
            created: charge[:created],
            currency: charge[:currency],
            type: "reçu"
          }
          @charges << @charge
        end
        if charge[:status] == "succeeded" && charge[:destination].nil? && charge[:refunded] == true
          refund = Stripe::Refund.retrieve(charge[:refunds][:data][0][:id])
          @refund = {
            id: refund[:id],
            charge_id: charge[:id],
            payment_intent: g.payment_intent_id,
            amount: refund[:amount],
            giftcard_id: g.id,
            created: refund[:created],
            currency: refund[:currency],
            type: "remboursée"
          }
          @charges << @refund
        end
        if g.stripe_transfers.size > 0
          g.stripe_transfers.split(",").each do |t|
            transfer = Stripe::Transfer.retrieve(t)
            @transfer = {
              id: t,
              charge_id: charge[:id],
              payment_intent: g.payment_intent_id,
              amount: transfer[:amount],
              destination: transfer[:destination],
              giftcard_id: g.id,
              created: transfer[:created],
              currency: transfer[:currency],
              type: "viré au partenaire"
            }
            @charges << @transfer
            if transfer[:amount_reversed].to_f > 0
              transfer_reversal = Stripe::Transfer.retrieve_reversal(t, transfer[:reversals][:data][0][:id])
              @transfer_reversal = {
                id: transfer_reversal[:id],
                charge_id: charge[:id],
                payment_intent: g.payment_intent_id,
                amount: transfer_reversal[:amount],
                destination: transfer[:destination],
                giftcard_id: g.id,
                created: transfer_reversal[:created],
                currency: transfer_reversal[:currency],
                type: "reçu du partenaire"
              }
              @charges << @transfer_reversal
            end
          end
        end
      end
      @charges
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end

  private

  def set_profile
    @profile = Profile.friendly.find(params[:id])
    authorize @profile
  end


  def set_profile_and_verify
    if Profile.friendly.find(params[:id])
      @profile = Profile.friendly.find(params[:id])
      if @profile.user == current_user || current_user.admin == true
        authorize @profile
      end
    end
  end

  def profile_params
    params.require(:profile).permit(:address, :zip_code, :city, :phone_number, :company, :siret_number, :website, :instagram, :role, :description, :ready, :accountant_company, :accountant_address, :accountant_zip_code, :accountant_city, :accountant_phone_number, :fee, :photo)
  end
end
