class StripeRefundService
  def call(event)

    if Booking.find_by(charge_id: event.data.object.id)
      @booking = Booking.find_by(charge_id: event.data.object.id)
      @booking.update(status: 'refunded')

      mail_cancel_btob = BookingMailer.with(booking: @booking).cancel_booking_btob
      mail_cancel_btob.deliver_now
      if @booking.session.workshop.animators.where(db_status: true).present?
        mail_cancel_btob_2 = BookingMailer.with(booking: @booking).cancel_booking_btob_animator
        mail_cancel_btob_2.deliver_now
      end
      mail_cancel_btoc = BookingMailer.with(booking: @booking).cancel_booking_btoc
      mail_cancel_btoc.deliver_later

    elsif Giftcard.find_by(charge_id: event.data.object.id)

      @giftcard = Giftcard.find_by(charge_id: event.data.object.id)
      @giftcard.update(status: 'refunded')

    end
  end
end
