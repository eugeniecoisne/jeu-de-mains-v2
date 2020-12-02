class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(public)
  before_action :set_profile, only: %i(show edit update tableau_de_bord messagerie)

  def index
    @chatroom = Chatroom.new
    @profiles = policy_scope(Profile).where(role: 'animateur', db_status: true)
    authorize @profiles
    if params[:search].present?
      @profiles = @profiles.select { |profile| profile.company.include?(params[:search][:company])} if params[:search][:company].present?
      @profiles = @profiles.select { |profile| profile.thematics.include?(params[:search][:keyword])} if params[:search][:keyword].present?
      @profiles = @profiles.select { |profile| profile.district == params[:search][:place] || profile.big_city == params[:search][:place] } if params[:search][:place].present?
    end
  end

  def show
  end

  def edit
  end

  def update
    @profile.update(profile_params)
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
    if params[:giftcard].present?
      if params[:giftcard][:code].present?
        @giftcard = Giftcard.find_by(code: params[:giftcard][:code])
        @giftcard.update(user_id: current_user.id)
        @giftcard.update(receiver: current_user.id)
        @giftcard.save
        redirect_to giftcard_confirmation_enregistrement_path(@giftcard)
      end
    end
  end

  def tableau_de_bord
    @users = User.all.where(db_status: true).select { |user| user.profile.role == 'animateur' }
    @animator = Animator.new
    @session = Session.new
    @workshop = Workshop.new
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

  private

  def set_profile
    if Profile.friendly.find(params[:id]).db_status == true
      @profile = Profile.friendly.find(params[:id])
      authorize @profile
    end
  end

  def profile_params
    params.require(:profile).permit(:address, :zip_code, :city, :phone_number, :company, :siret_number, :website, :instagram, :role, :description, :photo)
  end
end
