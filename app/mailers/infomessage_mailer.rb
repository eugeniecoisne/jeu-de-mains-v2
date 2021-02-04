class InfomessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.infomessage_mailer.new_information.subject
  #
  def new_information
    @infomessage = params[:infomessage]
    @organizer = @infomessage.session.workshop.place.user.email
    @participants = @infomessage.session.bookings.where(db_status: true, status: "paid").map { |booking| booking.user.email}.uniq.join(",")

    if @infomessage.session.workshop.animators.where(db_status: true).present?
      @animator = @infomessage.session.workshop.animators.where(db_status: true).last.user.email

      mail(
        bcc:       "#{@participants}, #{@organizer}, #{@animator}",
        subject:  "Vous avez reçu un message concernant l'atelier #{@infomessage.session.workshop.title}",
        track_opens: 'true',
        message_stream: 'outbound')

    else

      mail(
        bcc:       "#{@participants}, #{@organizer}",
        subject:  "Vous avez reçu un message concernant l'atelier #{@infomessage.session.workshop.title}",
        track_opens: 'true',
        message_stream: 'outbound')


    end
  end
end
