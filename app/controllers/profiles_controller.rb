class ProfilesController < ApplicationController
  before_action :set_profile, only: %i(show edit update)

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

  private

  def set_profile
    @profile = Profile.find(params[:id])
    authorize @profile
  end

  def profile_params
    params.require(:profile).permit(:last_name, :first_name, :address, :zip_code, :city, :phone_number, :company, :siret_number, :website, :instagram, :description)
  end
end
