class StripeCheckoutSessionService
  def call(event)

    if Booking.find_by(checkout_session_id: event.data.object.id)
      booking = Booking.find_by(checkout_session_id: event.data.object.id)
      booking.update(status: 'paid', payment_intent_id: event.data.object.payment_intent)

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

    elsif Giftcard.find_by(checkout_session_id: event.data.object.id)
      giftcard = Giftcard.find_by(checkout_session_id: event.data.object.id)
      giftcard.update(status: 'paid', payment_intent_id: event.data.object.payment_intent)

      # envoi de mails avec la carte cadeau etc

    end
  end
end