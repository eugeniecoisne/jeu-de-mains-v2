class BookingsController < ApplicationController

  skip_before_action :verify_authenticity_token, :only => :update

  def create
    session = Session.find(params[:session])
    workshop = session.workshop
    quantity = params[:quantity].to_i
    @booking = Booking.create!(
      status: 'pending',
      quantity: quantity,
      amount: quantity * workshop.price,
      session: session,
      user: current_user
      )
    authorize @booking

    redirect_to booking_options_path(@booking)
  end

  def update
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.update(booking_params)
    if @booking.giftcard_id.present? && @booking.giftcard_amount_spent.nil?
      giftcard = Giftcard.all.find(@booking.giftcard_id.to_i)
      if giftcard.amount >= @booking.amount
        @booking.update(giftcard_amount_spent: @booking.amount)
      else
        @booking.update(giftcard_amount_spent: giftcard.amount)
      end
    end
    redirect_back fallback_location: root_path
  end

  def options
    @booking = Booking.find(params[:booking_id])
    authorize @booking
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking

    key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
    Stripe.api_key = key

    # Retrouver si paiement que en carte bancaire ou CC + CB ou CC uniquement
    # Prévoir aussi règles de J-2 avant événement, 50% remboursés etc

    refund = Stripe::Refund.create({
      payment_intent: @booking.payment_intent_id,
      amount: (@booking.amount * 100).to_i,
      refund_application_fee: true,
      reverse_transfer: true,
    })

    @booking.update(refund_id: refund.id, charge_id: refund.charge, db_status: false)
    @booking.save

    redirect_back fallback_location: root_path
  end

  private

  def booking_params
    params.require(:booking).permit(:quantity, :status, :amount, :user_id, :session_id, :db_status, :checkout_session_id, :payment_intent_id, :charge_id, :refund_id, :cgv_agreement, :giftcard_id, :giftcard_amount_spent)
  end

end
