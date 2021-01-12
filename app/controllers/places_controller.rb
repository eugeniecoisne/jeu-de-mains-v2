class PlacesController < ApplicationController
  before_action :set_place, only: %i(edit update)

  def new
    @place = Place.new
    authorize @place
  end

  def create
    @place = Place.new(place_params)
    authorize @place
    @place.user = current_user
    if @place.save
      redirect_to new_workshop_path
    else
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
    params.require(:place).permit(:name, :address, :zip_code, :city, :phone_number, :ephemeral)
  end

end
