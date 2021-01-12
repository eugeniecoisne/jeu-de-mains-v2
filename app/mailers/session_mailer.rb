class SessionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.cancel_and_giveback.subject
  #
  def cancel_and_giveback
    @session = params[:session]
    @place = @session.workshop.place.email
    @participants = @session.bookings.where(db_status: true, status: "paid").map { |booking| booking.user.email}.uniq.join(",")

    if @session.workshop.animators.where(db_status: true).present?
      @animator = @session.workshop.animators.where(db_status: true).last.user.email

      mail(
        bcc:       "#{@participants}, #{@place}, #{@animator}",
        subject:  "Votre atelier a malheureusement été annulé",
        track_opens: 'true',
        message_stream: 'outbound')

    else

      mail(
        bcc:       "#{@participants}, #{@place}",
        subject:  "Votre atelier a malheureusement été annulé",
        track_opens: 'true',
        message_stream: 'outbound')


    end
  end
end
