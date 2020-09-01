class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(public)
  before_action :set_profile, only: %i(show edit update dashboard)

  def index
    @profiles = policy_scope(Profile).where(role: 'animateur')
    authorize @profiles
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
    @users = User.all.select { |user| user.profile.role == 'animateur' }
    @animator = Animator.new
    @session = Session.new
    @workshop = Workshop.new
  end

  def public
    @profile = Profile.find(params[:profile_id])
    authorize @profile
    @workshops = policy_scope(Workshop).where(status: 'en ligne')
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
    authorize @profile
  end

  def profile_params
    params.require(:profile).permit(:last_name, :first_name, :address, :zip_code, :city, :phone_number, :company, :siret_number, :website, :instagram, :description, :photo)
  end
end
