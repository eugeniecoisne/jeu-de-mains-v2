class WorkshopsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show)
  before_action :set_workshop, only: %i(show edit update)

  def index
    if params[:search].present?
      if params[:search][:starts_at].present? && params[:search][:ends_at].present?
        dates = (Date.strptime(params[:search][:starts_at], '%Y-%m-%d')..Date.strptime(params[:search][:ends_at], '%Y-%m-%d')).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne').select { |workshop| workshop.dates.any? { |date| dates.include?(date) } }
      elsif params[:search][:starts_at].present?
        @workshops = policy_scope(Workshop).where(status: 'en ligne').global_search(Date.strptime(params[:search][:starts_at], '%Y-%m-%d'))
      elsif params[:search][:ends_at].present?
        @workshops = policy_scope(Workshop).where(status: 'en ligne').global_search(Date.strptime(params[:search][:ends_at], '%Y-%m-%d'))
      else
        @workshops = policy_scope(Workshop).where(status: 'en ligne')
      end
      @workshops = @workshops.select { |workshop| workshop.thematic == params[:search][:keyword] } if params[:search][:keyword].present?
      @workshops = @workshops.select { |workshop| workshop.place.city == params[:search][:place] } if params[:search][:place].present?
    else
      @workshops = policy_scope(Workshop).where(status: 'en ligne')
    end
    # authorize @workshops

    @workshops = @workshops.select { |workshop| workshop.price <= params[:search][:price].to_f } if params[:search][:price].present?

    if params[:search][:order].present?
      case params[:search][:order]
      when 'Recommandation'
      when 'Dates proches'
      when 'Prix croissants'
        @workshops = @workshops.sort_by { |workshop| workshop.price }
      when 'Prix décroissants'
        @workshops = @workshops.sort_by { |workshop| workshop.price }.reverse
      when 'Les mieux notés'
        @workshops = @workshops.sort_by { |workshop| workshop.rating }.reverse
      end
    end

    @prices = @workshops.map { |ws| ws.price }
    @min_price = @prices.min
    @max_price = @prices.max

    @places_geo = Place.where(id: @workshops.pluck(:place_id))

    @markers = @places_geo.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { place: place })
      }
    end

  end

  def show
    @booking = Booking.new
    @animator = @workshop.animators.first
  end

  def edit
    @places = current_user.admin ? Place.all : current_user.places
  end

  def update
    @workshop.update(workshop_params)
    if @workshop.save
      redirect_to workshop_path(@workshop)
    else
      @places = current_user.admin ? Place.all : current_user.places
      render 'edit'
    end
  end

  def new
    @workshop = Workshop.new
    authorize @workshop
    @places = current_user.admin ? Place.all : current_user.places
  end

  def create
    @workshop = Workshop.new(workshop_params)
    authorize @workshop
    @workshop.place = Place.find(params[:workshop][:place_id])
    if @workshop.save
      redirect_to workshop_path(@workshop)
    else
      @places = current_user.admin ? Place.all : current_user.places
      render 'new'
    end
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
    authorize @workshop
  end

  def workshop_params
    params.require(:workshop).permit(:title, :program, :final_product, :thematic, :level, :duration, :price, :status, :capacity, photos: [])
  end
end
