class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i(show edit update)

  def index
    @workshops = policy_scope(Workshop).where(status: 'en ligne')
    authorize @workshops
  end

  def show
    @booking = Booking.new
    @animator = @workshop.animators.find_by(db_status: 'actif')
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
    params.require(:workshop).permit(:title, :program, :final_product, :thematic, :level, :duration, :price, :status, :capacity)
  end
end
