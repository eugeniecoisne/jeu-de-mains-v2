class ChatroomsController < ApplicationController

  def create
    @chatroom = Chatroom.new(chatroom_params_1)
    authorize @chatroom
    if @chatroom.save
      redirect_to chatroom_path(@chatroom)
    else
      redirect_back fallback_location: root_path
    end
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    authorize @chatroom
    @message = Message.new
  end

  def update
    @chatroom = Chatroom.find(params[:id])
    authorize @chatroom
    @chatroom.update(chatroom_params_2)
    if @chatroom.save
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
    end
  end

  private

  def chatroom_params_1
    params.require(:chatroom).permit(:user1, :user2, :room_name)
  end

  def chatroom_params_2
    params.require(:chatroom).permit(:room_name)
  end

end
