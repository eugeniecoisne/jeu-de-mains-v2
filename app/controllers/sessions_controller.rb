class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(search_places)

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
      redirect_to workshop_path(@session.workshop)
    else
      render 'new'
    end
  end

  def index
    @workshop = policy_scope(Workshop).find(params[:workshop_id])
    @sessions = @workshop.sessions
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
