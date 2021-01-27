require 'csv'
require 'rails/all'

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(search_places)
  skip_after_action :verify_authorized, only: [:update]

  def create
    @session = Session.new(session_params)
    authorize @session
    @session.workshop = Workshop.friendly.find(params[:workshop_id])
    @session.capacity = @session.workshop.capacity if @session.capacity.nil?
    if @session.save
      flash[:notice] = "Votre session a bien été ajoutée !"
    else
      flash[:notice] = "Votre session n'a pas pu être ajoutée, remplissez bien les champs obligatoires."
    end
    redirect_back fallback_location: root_path
  end

  def index
    @session = Session.new
    if policy_scope(Workshop).friendly.find(params[:workshop_id]).db_status == true
      @workshop = policy_scope(Workshop).friendly.find(params[:workshop_id])
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

  def annulation_et_remboursement
    @session = Session.find(params[:session_id])
    authorize @session
  end

  def destroy
    @session = Session.find(params[:id])
    authorize @session
    if @session.bookings.where(db_status: true, status: "paid").empty?
      @session.update(db_status: false)
      @session.save
      redirect_back fallback_location: root_path
    else
      @session.update(session_params)
      @session.update(db_status: false)
      @session.save
      mail = SessionMailer.with(session: @session).cancel_and_giveback
      mail.deliver_now
      @session.bookings.where(db_status: true, status: "paid").each do |b|
        b.destroy
        mail = BookingMailer.with(booking: b).cancel_booking_btoc
        mail.deliver_now
      end
      redirect_back fallback_location: root_path
      flash[:notice] = "Votre session a bien été annulée et les participants ont été prévenus par e-mail."
          # rembourser participants base 100%
    end
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
    @infomessage = Infomessage.new
  end

  def expedition_kits
    if Session.find(params[:session_id]).db_status == true
      @session = Session.find(params[:session_id])
      authorize @session
      @bookings = @session.bookings.where(db_status: true, status: "paid")
      respond_to do |format|
        format.html
        format.csv { send_data @bookings.to_csv }
        format.xls
      end
    end
  end

  private

  def session_params
    params.require(:session).permit(:date, :start_at, :capacity, :reason)
  end
end
