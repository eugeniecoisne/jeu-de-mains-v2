class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(new)

  def new
    @booking = current_user.bookings.where(status: 'pending').find(params[:booking_id])
    authorize @booking
  end
end
