class PlacesController < ApplicationController
  before_action :set_place, only: %i(edit update)

  def new
    @place = Place.new
    authorize @place
    session[:prev_url] = request.referer
  end

  def create
    @place = Place.new(place_params)
    authorize @place
    @place.user = current_user
    if @place.save
      flash[:notice] = "Une nouvelle adresse a été ajoutée à vos adresses."
      redirect_to session[:prev_url]
    else
      flash[:alert] = "Le formulaire semble incomplet."
      render 'new'
    end
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
    params.require(:place).permit(:name, :address, :zip_code, :city, :phone_number)
  end

end
