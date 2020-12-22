class BookingsController < ApplicationController

  def create
    session = Session.find(params[:session])
    workshop = session.workshop
    quantity = params[:quantity].to_i
    @booking = Booking.create!(
      quantity: quantity,
      amount: quantity * workshop.price,
      session: session,
      status: 'pending',
      user: current_user
      )
    authorize @booking

    key = @booking.session.workshop.place.user.access_code
    Stripe.api_key = key

    price = Stripe::Price.retrieve(@booking.session.stripe_price_id)

    customer = if current_user.stripe_id?
                Stripe::Customer.retrieve(current_user.stripe_id)
              else
                Stripe::Customer.create(email: current_user.email)
              end
    current_user.update(stripe_id: customer.id)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer: customer,
      payment_intent_data: {
        application_fee_amount: (0.18 * @booking.amount * 100).to_i,
      },
      line_items: [{
        price: price,
        quantity: @booking.quantity
      }],
      mode: 'payment',
      success_url: tableau_de_bord_profile_url(current_user.profile),
      cancel_url: tableau_de_bord_profile_url(current_user.profile)
    )

    @booking.update(checkout_session_id: session.id)

    redirect_to new_booking_payment_path(@booking)

  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking

    key = @booking.session.workshop.place.user.access_code
    Stripe.api_key = key

    # Retrouver si paiement que en carte bancaire ou CC + CB ou CC uniquement
    # Prévoir aussi règles de J-2 avant événement, 50% remboursés etc

    refund = Stripe::Refund.create({
      payment_intent: @booking.payment_intent_id,
      amount: (@booking.amount * 100).to_i,
      refund_application_fee: true
    })

    @booking.update(refund_id: refund.id, charge_id: refund.charge, db_status: false)
    @booking.save

    redirect_back fallback_location: root_path
  end

end
