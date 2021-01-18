class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(new)

  def new
    @booking = current_user.bookings.where(status: 'pending').find(params[:booking_id])
    authorize @booking
    if @booking.cgv_agreement == true

      if @booking.giftcard_id.present? && @booking.giftcard_amount_spent.present?
        amount = ((@booking.amount - @booking.giftcard_amount_spent) * 100).to_i
      else
        amount = (@booking.amount * 100).to_i
      end

      customer = if current_user.stripe_id.present?
                    Stripe::Customer.retrieve(current_user.stripe_id)
                  else
                    Stripe::Customer.create(email: current_user.email)
                  end

      current_user.update(stripe_id: customer.id)

      if @booking.giftcard_amount_spent != @booking.amount

        session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          customer: customer,
          payment_intent_data: {
            application_fee_amount: (0.20 * amount).to_i,
            transfer_data: {
              destination: @booking.session.workshop.place.user.stripe_uid,
            },
          },
          line_items: [{
            amount: amount,
            currency: "eur",
            description: "#{@booking.session.workshop.program[0..150]}(...)",
            name: "Atelier #{@booking.session.workshop.title} du #{@booking.session.date.strftime("%d/%m/%y")} à #{@booking.session.start_at}",
            quantity: 1,
            images: [@booking.session.workshop.photos[0].service_url]
          }],
          mode: 'payment',
          success_url: booking_payment_success_url(@booking),
          cancel_url: booking_payment_error_url(@booking)
        )
        @booking.update(checkout_session_id: session.id)

      end

    else
      flash[:alert] = "Vous devez donner votre accord sur les conditions générales de vente de Jeu de Mains pour continuer"
      redirect_back fallback_location: root_path
    end
  end
end
