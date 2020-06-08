class ReviewsController < ApplicationController

  def new
    @review = Review.new
    authorize @review
    @booking = Booking.find(params[:booking_id])
  end

  def create
    @review = Review.new(review_params)
    authorize @review
    @review.booking = Booking.find(params[:booking_id])
    @review.user = current_user
    if @review.save
      redirect_to profile_path(current_user.profile)
    else
      render 'new'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
