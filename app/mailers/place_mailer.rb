class PlaceMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.place_mailer.create_confirmation.subject
  #
  def create_confirmation
    @place = params[:place]

    mail(
      to:       @place.user.email,
      subject:  "Votre lieu #{@place.name} a bien été créé !"
      track_opens: 'true',
      message_stream: 'outbound')
  end
end
