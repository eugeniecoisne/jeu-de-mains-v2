class PlacesController < ApplicationController
  before_action :set_place, only: %i(edit update)

  def new
    @place = Place.new
    authorize @place
    @users = User.all.where(db_status: true).select { |user| user.profile.role.present? }
  end

  def create
    @place = Place.new(place_params)
    authorize @place
    @place.user = User.find(params[:place][:user_id])
    if @place.save
      redirect_back fallback_location: root_path
    else
      @users = User.all.where(db_status: true).select { |user| user.profile.role.present? }
      render 'new'
    end
  end

  def edit
  end

  def update
    @place.update(place_params)
    if @place.save
      redirect_back fallback_location: root_path
    else
      render 'edit'
    end
  end

  private

  def set_place
    if Place.find(params[:id]).db_status == true
      @place = Place.find(params[:id])
      authorize @place
    end
  end

  def place_params
    params.require(:place).permit(:name, :address, :zip_code, :city, :description, :phone_number, :email, :ephemeral, :siret_number, :website, :instagram)
  end

end
