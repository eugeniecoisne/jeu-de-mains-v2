class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    my_today_messages = @chatroom.messages.select { |message| message.user == current_user }.select { |message| message.created_at > Time.now - 2.hours}
    authorize @message
    if @message.save
      if my_today_messages.size == 0
        mail = MessageMailer.with(message: @message).new_message
        mail.deliver_now
      end
      redirect_to chatroom_path(@chatroom, anchor: "message-#{@message.id}")
    else
      render "chatrooms/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:title, :content)
  end
end
