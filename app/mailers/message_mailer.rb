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
        subject:  "#{@message.user.profile.company} vous a envoyé un message",
        track_opens: 'true',
        message_stream: 'outbound')
    else
      mail(
        to:       User.find(@message.chatroom.user1).email,
        subject:  "#{@message.user.profile.company} vous a envoyé un message",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end
end
