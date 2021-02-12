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
        bcc:       "#{@organizer.email}, #{@animator.email}",
        subject:  "Vous avez reçu un nouvel avis !",
        track_opens: 'true',
        message_stream: 'outbound')
    else
      mail(
        to:       "#{@organizer.email}",
        subject:  "Vous avez reçu un nouvel avis !",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end

  def report_review
    @review = params[:review]

    mail(
    to:       "contact@jeudemains.com",
    subject:  "Avis signalé par #{@review.booking.session.workshop.place.user.profile.company}, à vérifier",
    track_opens: 'true',
    message_stream: 'outbound')
  end

end
