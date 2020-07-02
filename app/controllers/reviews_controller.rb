class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index)
  skip_after_action :verify_policy_scoped, :only => :index

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
      redirect_to dashboard_profile_path(current_user.profile)
    else
      render 'new'
    end
  end

  def index
    if params[:workshop_id]
      @workshop = Workshop.find(params[:workshop_id])
      authorize @workshop
    elsif params[:place_id]
      @place = Place.find(params[:place_id])
      authorize @place
    elsif params[:profile_id]
      @profile = Profile.find(params[:profile_id])
      authorize @profile
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
