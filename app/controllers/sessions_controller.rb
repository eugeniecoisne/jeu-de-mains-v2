class SessionsController < ApplicationController

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

  def search_places
    @session = Session.find(params[:session_id])
    authorize @session
    @number = @session.available
    render json: @number
  end

  def capacity
    if @capacity.nil?
      @workshop.capacity
    else
      @capacity
    end
  end

  private

  def session_params
    params.require(:session).permit(:date, :start_at, :capacity)
  end
end
