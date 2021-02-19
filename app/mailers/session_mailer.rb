class SessionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.cancel_and_giveback.subject
  #
  def cancel_and_giveback
    @session = params[:session]
    @organizer = @session.workshop.place.user.email
    @participants = @session.bookings.where(db_status: true, status: "paid").map { |booking| booking.user.email}.uniq.join(",")

    if @session.workshop.animators.where(db_status: true).present?
      @animator = @session.workshop.animators.where(db_status: true).last.user.email

      mail(
        bcc:       "#{@participants}, #{@organizer}, #{@animator}, contact@jeudemains.com",
        subject:  "Votre atelier a malheureusement été annulé",
        track_opens: 'true',
        message_stream: 'outbound')

    else

      mail(
        bcc:       "#{@participants}, #{@organizer}, contact@jeudemains.com",
        subject:  "Votre atelier a malheureusement été annulé",
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
