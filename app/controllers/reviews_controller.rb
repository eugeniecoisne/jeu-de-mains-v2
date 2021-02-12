class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index)
  skip_after_action :verify_policy_scoped, :only => :index

  def new
    @review = Review.new
    authorize @review
    @booking = Booking.find(params[:booking_id])
  end

  def create
    @booking = Booking.find(params[:booking_id])
    if @booking.status == "paid" && @booking.db_status == true && @booking.user == current_user
      @review = Review.new(review_params)
      authorize @review
      @review.booking = @booking
      @review.user = current_user
      if @review.save
        mail = ReviewMailer.with(review: @review).new_review
        mail.deliver_later
        flash[:notice] = "Votre avis a bien été posté !"
        redirect_to tableau_de_bord_profile_path(current_user.profile)
      else
        flash[:alert] = "Une erreur s'est produite."
        render 'new'
      end
    else
      flash[:alert] = "Une erreur s'est produite."
      render 'new'
    end
  end

  def index
    if params[:workshop_id]
      @workshop = Workshop.friendly.find(params[:workshop_id]) if Workshop.friendly.find(params[:workshop_id]).db_status == true
    elsif params[:profile_id]
      @profile = Profile.friendly.find(params[:profile_id]) if Profile.friendly.find(params[:profile_id]).db_status == true
    end
  end

  def report_review
    if params[:report].present?
      @review = Review.find(params[:report][:review_id])
      authorize @review
      @review.update(db_status: false)
      mail_report = ReviewMailer.with(review: @review).report_review
      mail_report.deliver_later
      flash[:notice] = "Votre avis a été dépublié et sera prochainement vérifié par nos équipes."
      redirect_back fallback_location: root_path
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
