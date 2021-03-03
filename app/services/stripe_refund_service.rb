class StripeRefundService
  def call(event)

    if Booking.find_by(charge_id: event.data.object.id)
      @booking = Booking.find_by(charge_id: event.data.object.id)
      @booking.update(status: 'refunded', cancelled_at: Time.now)

      if @booking.giftcard_amount_spent.present?
        key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
        Stripe.api_key = key

        # ETAPE 2
        # JDM reprend à l'organisateur le montant de la carte cadeau utilisé sans la commission.

        Stripe::Transfer.create_reversal(@booking.stripe_giftcard_transfer,
          {amount: ((@booking.giftcard_amount_spent * @booking.refund_rate * (1.0 - @booking.fee)) * 100).to_i},
        )

        # ETAPE 3
        # JDM réinjecte l'argent de la CC dans la CC et si CC expirée, ajout de 1 mois.

        giftcard = Giftcard.find(@booking.giftcard_id.to_i)

          # carte cadeau périmée, ajout de un mois de validité + montant.
        if giftcard.deadline_date < Date.today
          giftcard.amount += (@booking.giftcard_amount_spent * @booking.refund_rate)
          giftcard.deadline_date = Date.today + 1.month
          giftcard.save
        else
          giftcard.amount += (@booking.giftcard_amount_spent * @booking.refund_rate)
          giftcard.save
        end
      end

      SendCancelBookingEmailsJob.perform_now(@booking)

    elsif Giftcard.find_by(charge_id: event.data.object.id)

      @giftcard = Giftcard.find_by(charge_id: event.data.object.id)
      @giftcard.update(status: 'refunded', refunded_at: Time.now)

    end
  end
end
