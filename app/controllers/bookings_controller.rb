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
