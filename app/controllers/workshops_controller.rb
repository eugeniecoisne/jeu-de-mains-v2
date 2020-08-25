class WorkshopsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show)
  before_action :set_workshop, only: %i(show edit update confirmation)

  def index
    if params[:search].present?
      if params[:search][:starts_at].present? && params[:search][:ends_at].present?
        dates = (Date.strptime(params[:search][:starts_at], '%Y-%m-%d')..Date.strptime(params[:search][:ends_at], '%Y-%m-%d')).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne').select { |workshop| workshop.dates.any? { |date| dates.include?(date) } }
      elsif params[:search][:starts_at].present?
        dates = (Date.strptime(params[:search][:starts_at], '%Y-%m-%d')..Date.today + 3.months).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne').select { |workshop| workshop.dates.any? { |date| dates.include?(date) } }
      elsif params[:search][:ends_at].present?
        dates = (Date.today..Date.strptime(params[:search][:ends_at], '%Y-%m-%d')).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne').select { |workshop| workshop.dates.any? { |date| dates.include?(date) } }
      else
        @workshops = policy_scope(Workshop).where(status: 'en ligne')
      end

      @workshops = @workshops.select { |workshop| workshop.thematic == params[:search][:keyword] } if params[:search][:keyword].present?
      @workshops = @workshops.select { |workshop| workshop.place.city == params[:search][:place] } if params[:search][:place].present?

      if params[:search][:min_price].present? && params[:search][:max_price].present?

        min_price = params[:search][:min_price].to_f
        max_price = params[:search][:max_price].to_f

        if min_price > max_price
          @workshops = @workshops.select do |workshop|
            workshop.price <= min_price
            workshop.price >= max_price
          end
        elsif min_price == max_price
          @workshops = @workshops.select do |workshop|
            workshop.price == min_price
          end
        else
          @workshops = @workshops.select do |workshop|
            workshop.price <= max_price
            workshop.price >= min_price
          end
        end
      end

      if params[:search][:ephemeral].present?
        if params[:search][:ephemeral] == 'false'
          @workshops = @workshops.select { |workshop| workshop.place.ephemeral == false }
        end
      end

      if params[:search][:order].present?
        case params[:search][:order]
        when 'Recommandation'
          @workshops = @workshops.sort_by { |workshop| workshop.recommendable }.reverse
        when 'Prix croissants'
          @workshops = @workshops.sort_by { |workshop| workshop.price }
        when 'Prix décroissants'
          @workshops = @workshops.sort_by { |workshop| workshop.price }.reverse
        when 'Les mieux notés'
          @workshops = @workshops.sort_by { |workshop| workshop.rating }.reverse
        end
      end
    else
      @workshops = policy_scope(Workshop).where(status: 'en ligne')
    end
    # authorize @workshops

    @prices = @workshops.map { |ws| ws.price }
    @min_price = @prices.present? ? @prices.min : 0
    @max_price = @prices.present? ? @prices.max : 0

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
    @animators = Profile.where(role: 'animateur')
  end

  def update
    @workshop.update(workshop_params)
    if @workshop.save
      flash[:notice] = "Votre atelier a bien été modifié !"
      redirect_to dashboard_profile_path(@workshop.place.user.profile)
    else
      @places = current_user.admin ? Place.all : current_user.places
      render 'edit'
    end
  end

  def new
    @workshop = Workshop.new
    authorize @workshop
    @places = current_user.admin ? Place.all : current_user.places
    @animators = Profile.where(role: 'animateur')
  end

  def create
    @workshop = Workshop.new(workshop_params)
    authorize @workshop
    @workshop.place = Place.find(params[:workshop][:place_id])
    @workshop.status = 'hors ligne'
    if @workshop.save
      flash[:notice] = "Votre atelier a bien été créé !"
      redirect_to confirmation_workshop_path(@workshop)
    else
      @places = current_user.admin ? Place.all : current_user.places
      render 'new'
    end
  end

  def confirmation
    @users = User.all.select { |user| user.profile.role == 'animateur' }
    @animator = Animator.new
    @session = Session.new
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
    authorize @workshop
  end

  def workshop_params
    params.require(:workshop).permit(:title, :program, :final_product, :thematic, :level, :duration, :price, :status, :capacity, :recommendable, photos: [])
  end
end
