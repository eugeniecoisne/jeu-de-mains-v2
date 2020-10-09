class WorkshopMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.workshop_mailer.create_confirmation.subject
  #
  def create_confirmation
    @workshop = params[:workshop]

    mail(
      to:       @workshop.place.user.email,
      subject:  "Votre atelier #{@workshop.title} a bien été créé, mettez-le en ligne !"
      track_opens: 'true',
      message_stream: 'outbound')
  end
end
