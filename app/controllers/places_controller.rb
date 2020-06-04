class PlacesController < ApplicationController
  before_action :set_place, only: %i(show edit update)

  def show
  end

  def new
    @place = Place.new
    authorize @place
    @users = User.all
  end

  def create
    @place = Place.new(place_params)
    authorize @place
    @place.user = User.find(params[:place][:user_id])
    if @place.save
      redirect_to place_path(@place)
    else
      @users = User.all
      render 'new'
    end
  end

  def edit
  end

  def update
    @place.update(place_params)
    if @place.save
      redirect_to place_path(@place)
    else
      render 'edit'
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
    authorize @place
  end

  def place_params
    params.require(:place).permit(:name, :address, :zip_code, :city, :description, :phone_number, :email, :ephemeral, :siret_number, :website, :instagram)
  end

end
