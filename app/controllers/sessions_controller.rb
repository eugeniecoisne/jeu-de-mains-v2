require 'csv'
require 'rails/all'

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(search_places)
  skip_after_action :verify_authorized, only: [:update]

  def create
      if params[:session]["start_date(3i)"].present? && params[:session]["end_date(3i)"].present?
        start_session_date = Date.parse("#{params[:session]["start_date(3i)"]}-#{params[:session]["start_date(2i)"]}-#{params[:session]["start_date(1i)"]}")
        end_session_date = Date.parse("#{params[:session]["end_date(3i)"]}-#{params[:session]["end_date(2i)"]}-#{params[:session]["end_date(1i)"]}")
        distance_in_hours = ((end_session_date.to_time - start_session_date.to_time) / 1.minutes).to_i + 1440
      end

      if start_session_date.present? && end_session_date.present? && start_session_date > end_session_date
        @session = Session.new
      elsif distance_in_hours.present? && (Workshop.friendly.find(params[:workshop_id]).duration.to_i != distance_in_hours)
        @session = Session.new
      else
        @session = Session.new(session_params)
      end
      authorize @session
      @session.workshop = Workshop.friendly.find(params[:workshop_id])
      @session.capacity = @session.workshop.capacity if @session.capacity.nil?
      if session_params.include?(:one_day)
        @session.end_date = @session.start_date
        session_start_time = Time.new(@session.start_date.strftime('%Y').to_i, @session.start_date.strftime('%m').to_i, @session.start_date.strftime('%d').to_i, @session.start_time[0..1], @session.start_time[-2..-1], 0, "+01:00")
        session_end_time = session_start_time + @session.workshop.duration.minutes
        @session.end_time = session_end_time.strftime("%Hh%M")
      end
      if @session.save
        flash[:notice] = "Votre session a bien été ajoutée !"
      else
        flash[:alert] = "Votre session n'a pas pu être ajoutée, vos informations sont incomplètes ou incorrectes."
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

  def annulation
    @session = Session.find(params[:session_id])
    authorize @session
  end

  def destroy
    @session = Session.find(params[:id])
    authorize @session
    if @session.sold == 0
      @session.update(db_status: false)
      @session.save
      redirect_back fallback_location: root_path
    else
      @session.update(session_params)
      @session.update(db_status: false)
      @session.save
      # mail btoc information annulation session et invitation à reporter ou demander remboursement
      @session.bookings.where(db_status: true, status: "paid").each do |b|
        BookingMailer.with(booking: b).cancel_session_by_partner_btoc.deliver_now
      end
      # mail btob confirmation annulation session
      SessionMailer.with(session: @session).cancel_session_by_partner_btob.deliver_now

      session_start_time = Time.new(@session.start_date.strftime('%Y').to_i, @session.start_date.strftime('%m').to_i, @session.start_date.strftime('%d').to_i, @session.start_time[0..1], @session.start_time[-2..-1], 0, "+01:00")
      cancel_time = Time.now
      if (0..47.99).include?(( session_start_time - cancel_time) / 1.hours)
        mail_phone_numbers = SessionMailer.with(session: @session).send_phone_numbers
        mail_phone_numbers.deliver_later
      end
      redirect_back fallback_location: root_path
      flash[:notice] = "Votre session a bien été annulée et les participants ont été prévenus par e-mail."
    end
  end

  def search_places
    @session = Session.find(params[:session_id])
    authorize @session
    if @session.workshop.kit == true && (@session.start_date - 6.days) < Date.today
      @number = 0
    else
      @number = @session.available
    end
    render json: @number
  end

  def participants
    if Session.find(params[:session_id]).db_status == true
      @session = Session.find(params[:session_id])
      authorize @session
    end
    @infomessage = Infomessage.new
  end

  def send_visio_information
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
        format.csv
        format.xls
      end
    end
  end

  private

  def session_params
    params.require(:session).permit(:start_date, :end_date, :start_time, :end_time, :capacity, :reason, :one_day)
  end
end
