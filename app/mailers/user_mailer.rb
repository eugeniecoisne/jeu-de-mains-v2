class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #

  def welcome
    @user = params[:user]
    mail(to: @user.email,
      subject: 'Jeu de Mains vous souhaite la bienvenue !',
      track_opens: 'true',
      message_stream: 'outbound')

  end

end
