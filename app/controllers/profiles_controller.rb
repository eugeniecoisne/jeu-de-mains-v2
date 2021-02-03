class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(public)
  before_action :set_profile, only: %i(edit update messagerie send_welcome_partner_email)
  before_action :set_profile_and_verify, only: %i(show tableau_de_bord)

  def index
    @chatroom = Chatroom.new
    @profiles = policy_scope(Profile).where(db_status: true).select { |profile| profile.role.present? }
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
      redirect_to profile_path(@profile)
    else
      redirect_to profile_path(@profile)
    end
  end

  def mes_cartes_cadeaux
    if Profile.friendly.find(params[:id]).db_status == true && Profile.friendly.find(params[:id]).role.present? == false
      @profile = Profile.friendly.find(params[:id])
      authorize @profile
      @giftcards = policy_scope(Giftcard).all
    end
  end

  def tableau_de_bord
    @users = User.all.where(db_status: true).select { |user| user.profile.role.present? && user != current_user }
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

  def send_welcome_partner_email
    mail = PartnerMailer.with(profile: @profile).send_welcome_partner_email
    mail.deliver_later
    flash[:notice] = "L'e-mail a bien été envoyé !"
    redirect_back fallback_location: root_path
  end

  private

  def set_profile
    if Profile.friendly.find(params[:id]).db_status == true
      @profile = Profile.friendly.find(params[:id])
      authorize @profile
    end
  end


  def set_profile_and_verify
    if Profile.friendly.find(params[:id]).db_status == true
      @profile = Profile.friendly.find(params[:id])
      if @profile.user == current_user
        authorize @profile
      end
    end
  end

  def profile_params
    params.require(:profile).permit(:address, :zip_code, :city, :phone_number, :company, :siret_number, :website, :instagram, :role, :description, :photo)
  end
end
