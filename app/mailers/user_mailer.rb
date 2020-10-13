class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #

  def welcome
    @user = params[:user]
    if @user.created_at >= Date.today - 7
      mail(from: 'contact@jeudemains.com',
        to: @user.email,
        subject: 'Jeu de Mains vous souhaite la bienvenue !',
        track_opens: 'true',
        message_stream: 'outbound')

    end
  end

end
