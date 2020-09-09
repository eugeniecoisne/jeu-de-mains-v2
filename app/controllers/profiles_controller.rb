class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(public)
  before_action :set_profile, only: %i(show edit update dashboard chat)

  def index
    @profiles = policy_scope(Profile).where(role: 'animateur', db_status: true)
    authorize @profiles
    if params[:search].present?
      @profiles = @profiles.select { |profile| profile.company.include?(params[:search][:company])} if params[:search][:company].present?
      @profiles = @profiles.select { |profile| profile.thematics.include?(params[:search][:keyword])} if params[:search][:keyword].present?
      @profiles = @profiles.select { |profile| profile.city == params[:search][:place] } if params[:search][:place].present?
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
      render 'edit'
    end
  end

  def dashboard
    @users = User.all.where(db_status: true).select { |user| user.profile.role == 'animateur' }
    @animator = Animator.new
    @session = Session.new
    @workshop = Workshop.new
  end

  def chat
    @user_chatrooms = []
    Chatroom.all.each do |chatroom|
      if User.find(chatroom.user1) == current_user || User.find(chatroom.user2) == current_user
        @user_chatrooms << chatroom
      end
    end
    @user_chatrooms
  end

  def public
    if Profile.find(params[:profile_id]).db_status == true
      @profile = Profile.find(params[:profile_id])
      authorize @profile
    end
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true)
  end

  private

  def set_profile
    if Profile.find(params[:id]).db_status == true
      @profile = Profile.find(params[:id])
      authorize @profile
    end
  end

  def profile_params
    params.require(:profile).permit(:last_name, :first_name, :address, :zip_code, :city, :phone_number, :company, :siret_number, :website, :instagram, :description, :photo)
  end
end
