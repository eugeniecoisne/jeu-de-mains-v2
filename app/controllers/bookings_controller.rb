class BookingsController < ApplicationController

  def create
    session = Session.find(params[:session])
    workshop = session.workshop
    quantity = params[:quantity].to_i
    @booking = Booking.create!(
      quantity: quantity,
      amount: quantity * workshop.price,
      session: session,
      user: current_user
      )
    authorize @booking
    mail_new_btob = BookingMailer.with(booking: @booking).new_booking_btob
    mail_new_btob.deliver_later
    if @booking.session.workshop.animators.where(db_status: true).present?
      mail_new_btob_2 = BookingMailer.with(booking: @booking).new_booking_btob_animator
      mail_new_btob_2.deliver_later
    end
    mail_new_btoc = BookingMailer.with(booking: @booking).new_booking_btoc
    mail_new_btoc.deliver_later
    mail_reminder_btoc = BookingMailer.with(booking: @booking).reminder_booking_btoc
    mail_reminder_btoc.deliver_later(wait_until: (@booking.session.date - 1).noon)
    mail_ask_review = BookingMailer.with(booking: @booking).ask_review_btoc
    mail_ask_review.deliver_later(wait_until: (@booking.session.date + 1).noon)
    redirect_to tableau_de_bord_profile_path(current_user.profile)
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    if @booking.session.date > Date.today + 2
      @booking.update(db_status: false)
      @booking.save
      mail_cancel_btob = BookingMailer.with(booking: @booking).cancel_booking_btob
      mail_cancel_btob.deliver_now
      if @booking.session.workshop.animators.where(db_status: true).present?
        mail_cancel_btob_2 = BookingMailer.with(booking: @booking).cancel_booking_btob_animator
        mail_cancel_btob_2.deliver_now
      end
      mail_cancel_btoc = BookingMailer.with(booking: @booking).cancel_booking_btoc
      mail_cancel_btoc.deliver_later
    end
    redirect_back fallback_location: root_path
  end

end
