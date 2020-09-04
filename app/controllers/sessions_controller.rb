class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(search_places)
  skip_after_action :verify_authorized, only: [:update]

  def create
    @session = Session.new(session_params)
    authorize @session
    @session.workshop = Workshop.find(params[:workshop_id])
    @session.capacity = @session.workshop.capacity if @session.capacity.nil?
    if @session.save
      flash[:notice] = "Votre session a bien été ajoutée !"
    end
    redirect_back fallback_location: root_path
  end

  def index
    if policy_scope(Workshop).find(params[:workshop_id]).db_status == true
      @workshop = policy_scope(Workshop).find(params[:workshop_id])
      @sessions = @workshop.sessions.where(db_status: true)
    end
  end

  def update
    @session = Session.find(params[:id])
    @session.update(session_params)
    if @session.save
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    @session = Session.find(params[:id])
    authorize @session
    if @session.bookings.empty?
      @session.update(db_status: false)
      @session.save
    end
    redirect_back fallback_location: root_path
  end

  def search_places
    @session = Session.find(params[:session_id])
    authorize @session
    @number = @session.available
    render json: @number
  end

  def participants
    if Session.find(params[:session_id]).db_status == true
      @session = Session.find(params[:session_id])
      authorize @session
    end
  end

  private

  def session_params
    params.require(:session).permit(:date, :start_at, :capacity)
  end
end
