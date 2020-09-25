class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.new_message.subject
  #
  def new_message
    @message = params[:message]

    if @message.user == User.find(@message.chatroom.user1)
      mail(
        to:       User.find(@message.chatroom.user2).email,
        subject:  "Vous avez reçu un message de #{@message.user.profile.company}"
      )
    else
      mail(
        to:       User.find(@message.chatroom.user1).email,
        subject:  "Vous avez reçu un message de #{@message.user.profile.company}"
      )
    end
  end
end
