class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index)
  skip_after_action :verify_policy_scoped, :only => :index

  def new
    if Booking.find(params[:booking_id]).db_status == true && Booking.find(params[:booking_id]).user == current_user
      @review = Review.new
      authorize @review
      @booking = Booking.find(params[:booking_id])
    end
  end

  def create
    @review = Review.new(review_params)
    authorize @review
    @review.booking = Booking.find(params[:booking_id])
    @review.user = current_user
    if @review.save
      mail = ReviewMailer.with(review: @review).new_review
      mail.deliver_now
      flash[:notice] = "Votre avis a bien été posté !"
      redirect_to tableau_de_bord_profile_path(current_user.profile)
    else
      flash[:alert] = "Une erreur s'est produite."
      render 'new'
    end
  end

  def index
    if params[:workshop_id]
      @workshop = Workshop.friendly.find(params[:workshop_id]) if Workshop.friendly.find(params[:workshop_id]).db_status == true
    elsif params[:place_id]
      @place = Place.friendly.find(params[:place_id]) if Place.friendly.find(params[:place_id]).db_status == true
    elsif params[:profile_id]
      @profile = Profile.friendly.find(params[:profile_id]) if Profile.friendly.find(params[:profile_id]).db_status == true
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
