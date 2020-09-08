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

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    if @booking.session.date > Date.today + 2
      @booking.update(db_status: false)
      @booking.save
    end
    redirect_back fallback_location: root_path
  end

end
