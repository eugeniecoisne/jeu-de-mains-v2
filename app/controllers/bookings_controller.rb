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
    redirect_to dashboard_profile_path(current_user.profile)
  end

end
