class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(search_places)
  skip_after_action :verify_authorized, only: [:update]

  def new
    @session = Session.new
    authorize @session
    @workshop = Workshop.find(params[:workshop_id])
  end

  def create
    @session = Session.new(session_params)
    authorize @session
    @session.workshop = Workshop.find(params[:workshop_id])
    @session.capacity = @session.workshop.capacity if @session.capacity.nil?
    if @session.save
      flash[:notice] = "Votre session a bien été ajoutée !"
      redirect_back fallback_location: root_path
    else
      render 'new'
    end
  end

  def index
    @workshop = policy_scope(Workshop).find(params[:workshop_id])
    @sessions = @workshop.sessions
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
    @session.destroy
    redirect_back fallback_location: root_path
  end

  def search_places
    @session = Session.find(params[:session_id])
    authorize @session
    @number = @session.available
    render json: @number
  end

  def participants
    @session = Session.find(params[:session_id])
    authorize @session
  end

  private

  def session_params
    params.require(:session).permit(:date, :start_at, :capacity)
  end
end
