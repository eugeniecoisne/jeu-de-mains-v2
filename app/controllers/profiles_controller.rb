class ProfilesController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i(public)
  before_action :set_profile, only: %i(edit update messagerie send_finalisation_partner_email)
  before_action :set_profile_and_verify, only: %i(show tableau_de_bord transactions releve_de_commissions)

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
          date: b.cancelled_at,
          label: "Remboursement - base #{(b.refund_rate * 100).round}%",
          workshop: b.session.workshop,
          session: b.session,
          booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
          amount: b.amount,
          fee_rate: b.fee,
          tva_applicable: b.tva_applicable,
          refund_rate: b.refund_rate,
          status: "refunded"
        }
        @transaction_bookings << @b_refund
      end
      @b_success = {
        booking: b,
        date: b.created_at,
        label: "Paiement reçu",
        workshop: b.session.workshop,
        session: b.session,
        booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
        amount: b.amount,
        fee_rate: b.fee,
        tva_applicable: b.tva_applicable,
        status: "success"
      }
      @transaction_bookings << @b_success
    end

    @transaction_bookings.sort_by { |b| b[:date] }

    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render pdf: "releve-facturation-clients-#{@profile.accountant_company.parameterize}-de-#{l(DateTime.new(params[:year].to_i, params[:month].to_i, 1), format: "%B-%Y")}",
              margin:  { top:10,bottom:10,left:10,right:10},
              footer: { right: 'Page [page] sur [topage]', font_size: 10 }
      end
    end
  end

  def releve_de_commissions
    @commission_bookings = []
    Booking.all.where(db_status: true).select { |b| b.status == "paid" || b.status == "refunded"}.select { |b| b.session.workshop.place.user.profile == @profile }.each do |b|
      if b.status == "refunded"
        @b_refund = {
          booking: b,
          date: b.cancelled_at,
          label: "Remboursement - base #{(b.refund_rate * 100).round}%",
          workshop: b.session.workshop,
          session: b.session,
          booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
          amount: b.amount,
          fee_rate: b.fee,
          tva_applicable: b.tva_applicable,
          refund_rate: b.refund_rate,
          status: "refunded"
        }
        @commission_bookings << @b_refund
      end
      @b_success = {
        booking: b,
        date: b.created_at,
        label: "Paiement reçu",
        workshop: b.session.workshop,
        session: b.session,
        booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
        amount: b.amount,
        fee_rate: b.fee,
        tva_applicable: b.tva_applicable,
        status: "success"
      }
      @commission_bookings << @b_success
    end

    @commission_bookings.sort_by { |b| b[:date] }

    respond_to do |format|
      format.pdf do
        if params[:year].present? && params[:month].present?
          @year = params[:year]
          @month = params[:month]
        end
        @fee_invoice = FeeInvoice.all.where(profile_id: @profile.id).select { |f| f.start_date == Date.new(@year.to_i, @month.to_i, 1) }.last
        render pdf: "facture-P-#{Array.new((6-(@fee_invoice.id.to_s.size)), "0").join('')}#{@fee_invoice.id}",
              margin:  { top:10,bottom:10,left:10,right:10},
              footer: { right: 'Page [page] sur [topage]', font_size: 10 }
      end
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
      @payments = []
      Booking.all.select { |b| b.status == "paid" || b.status == "refunded" }.each do |b|
        @success = {
          id: b.id,
          amount_ttc: b.amount,
          amount_ht: b.amount / 1.2,
          fee_ht: (b.amount / 1.2) * b.fee,
          fee_tva: (b.amount * b.fee) - ((b.amount / 1.2) * b.fee),
          fee_ttc: b.amount * b.fee,
          created: b.created_at.to_time,
          type: 'success'
        }
        if b.status == "refunded"
          @refund = {
            id: b.id,
            amount_ttc: b.amount * b.refund_rate * -1,
            amount_ht: (b.amount / 1.2) * b.refund_rate * -1,
            fee_ht: ((b.amount / 1.2) * b.refund_rate * -1) * b.fee,
            fee_tva: ((b.amount * b.refund_rate * -1) * b.fee) - (((b.amount / 1.2) * b.refund_rate * -1) * b.fee),
            fee_ttc: (b.amount * b.refund_rate * -1) * b.fee,
            created: b.cancelled_at.to_time,
            type: 'refund'
          }
        end
        @payments << @success if @success
        @payments << @refund if @refund
      end
      @payments
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
      @giftcards = []
      Giftcard.all.select { |g| g.status == "paid" || g.status == "refunded" }.each do |g|
        @g_success = {
          id: g.id,
          buyer_id: g.buyer,
          amount: g.initial_amount,
          amount_left: g.amount,
          created: g.created_at.to_time,
          type: 'success'
        }
        if g.status == "refunded"
          @g_refund = {
            id: g.id,
            buyer_id: g.buyer,
            amount: g.initial_amount * -1,
            amount_left: 0.0,
            created: g.refunded_at.to_time,
            type: 'refund'
          }
        end
        @giftcards << @g_success if @g_success
        @giftcards << @g_refund if @g_refund
      end
      @giftcards
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
    params.require(:profile).permit(:address, :zip_code, :city, :phone_number, :company, :siret_number, :website, :instagram, :role, :description, :ready, :accountant_company, :accountant_address, :accountant_zip_code, :accountant_city, :accountant_phone_number, :fee, :legal_mention, :tva_applicable, :tva_intra, :rcs_or_rm, :company_type, :company_capital, :photo)
  end
end
