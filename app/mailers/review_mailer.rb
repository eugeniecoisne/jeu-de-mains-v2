class ReviewMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.review_mailer.new_review.subject
  #
  def new_review
    @review = params[:review]
    @organizer = @review.booking.session.workshop.place.user
    if @review.booking.session.workshop.animators.where(db_status: true).present?
      @animator = @review.booking.session.workshop.animators.where(db_status: true).last.user

      mail(
        to:       "#{@organizer.email}, #{@animator.email}",
        subject:  "Vous avez reçu un nouvel avis pour l'atelier #{@review.booking.session.workshop.title} !"
      )
    else
      mail(
        to:       "#{@organizer.email}",
        subject:  "Vous avez reçu un nouvel avis pour l'atelier #{@review.booking.session.workshop.title} !"
      )
    end
  end

end
