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
      subject:  "Votre atelier #{@workshop.title} a bien été créé, mettez-le en ligne !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def workshop_is_online
    @workshop = params[:workshop]

    mail(
      to:       @workshop.place.user.email,
      subject:  "Votre atelier #{@workshop.title} est en ligne !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def workshop_cannot_be_online
    @workshop = params[:workshop]
    @message = params[:message] if params[:message].present?

    mail(
      to:       @workshop.place.user.email,
      subject:  "Votre atelier #{@workshop.title} n'a pas pu être mis en ligne",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def ask_for_check_up
    @workshop = params[:workshop]

    mail(
      to:       "contact@jeudemains.com",
      subject:  "Demande de vérification d'atelier #{@workshop.title}",
      track_opens: 'true',
      message_stream: 'outbound')
  end


end
