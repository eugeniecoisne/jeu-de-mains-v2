class StripeCheckoutSessionService
  def call(event)
    booking = Booking.find_by(checkout_session_id: event.data.object.id)
    booking.update(status: 'paid')

    mail_new_btob = BookingMailer.with(booking: booking).new_booking_btob
    mail_new_btob.deliver_later
    if booking.session.workshop.animators.where(db_status: true).present?
      mail_new_btob_2 = BookingMailer.with(booking: booking).new_booking_btob_animator
      mail_new_btob_2.deliver_later
    end
    mail_new_btoc = BookingMailer.with(booking: booking).new_booking_btoc
    mail_new_btoc.deliver_later
    mail_reminder_btoc = BookingMailer.with(booking: booking).reminder_booking_btoc
    mail_reminder_btoc.deliver_later(wait_until: (booking.session.date - 1).noon)
    mail_ask_review = BookingMailer.with(booking: booking).ask_review_btoc
    mail_ask_review.deliver_later(wait_until: (booking.session.date + 1).noon)
  end
end
