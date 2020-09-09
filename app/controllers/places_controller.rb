class PlacesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(show)
  before_action :set_place, only: %i(show edit update)

  def index
    @chatroom = Chatroom.new
    @places = policy_scope(Place).where(db_status: true)
    authorize @places
    if params[:search].present?
      @places = @places.select { |place| place.name.include?(params[:search][:company])} if params[:search][:company].present?
      @places = @places.select { |place| place.thematics.include?(params[:search][:keyword])} if params[:search][:keyword].present?
      @places = @places.select { |place| place.city.capitalize == params[:search][:place] } if params[:search][:place].present?
    end
  end

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
    if Place.find(params[:id]).db_status == true
      @place = Place.find(params[:id])
      authorize @place
    end
  end

  def place_params
    params.require(:place).permit(:name, :address, :zip_code, :city, :description, :phone_number, :email, :ephemeral, :siret_number, :website, :instagram, :photo)
  end

end
