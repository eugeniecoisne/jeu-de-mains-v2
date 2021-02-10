require 'stripe'

class StripeCheckoutSessionService
  def call(event)

    if Booking.find_by(checkout_session_id: event.data.object.id)
      booking = Booking.find_by(checkout_session_id: event.data.object.id)
      booking.update(status: 'paid', payment_intent_id: event.data.object.payment_intent)

      if booking.giftcard_id.present?
        giftcard = Giftcard.find(booking.giftcard_id.to_i)
        new_amount = giftcard.amount - booking.giftcard_amount_spent
        giftcard.update(amount: new_amount)

        key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
        Stripe.api_key = key

        charge = Stripe::PaymentIntent.retrieve(giftcard.payment_intent_id).charges.first

        transfer = Stripe::Transfer.create({
          amount: ((booking.giftcard_amount_spent - (booking.giftcard_amount_spent * 0.2)) * 100).to_i,
          currency: 'eur',
          transfer_group: "GIFTCARD_#{giftcard.id}",
          source_transaction: charge.id,
          destination: booking.session.workshop.place.user.stripe_uid,
        })

        giftcard.stripe_transfers << "#{transfer.id},"
        giftcard.save
        booking.update(stripe_giftcard_transfer: transfer.id)
      end

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

      mail_giftcard_btoc = GiftcardMailer.with(giftcard: giftcard).confirmation
      mail_giftcard_btoc.deliver_later

    end
  end
end
