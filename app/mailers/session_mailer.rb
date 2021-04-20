class SessionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.cancel_and_giveback.subject
  #
  def cancel_session_by_partner_btob
    @session = params[:session]
    @organizer = @session.workshop.place.user.email

    if @session.workshop.animators.where(db_status: true).present?
      @animator = @session.workshop.animators.where(db_status: true).last.user.email

      mail(
        bcc: "#{@organizer}, #{@animator}",
        subject:  "Annulation de l'atelier #{@session.workshop.title} du #{@session.start_date.strftime("%d/%m/%y")}",
        track_opens: 'true',
        message_stream: 'outbound')
    else

      mail(
        to:       @organizer,
        subject:  "Annulation de l'atelier #{@session.workshop.title} du #{@session.start_date.strftime("%d/%m/%y")}",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end


  def send_phone_numbers
    @session = params[:session]
    @organizer = @session.workshop.place.user.email

    mail(
      to:       @organizer,
      bcc:      'contact@jeudemains.com',
      subject:  "Vous avez annulé votre atelier, merci de contacter les participants",
      track_opens: 'true',
      message_stream: 'outbound')
  end
end
