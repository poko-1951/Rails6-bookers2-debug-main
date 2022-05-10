class MessagesController < ApplicationController
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.new(params.require(:message).permit(:user_id, :room_id, :message).merge(user_id: current_user.id))
      unless @message.save
        flash[:alert] = "1文字以上入力してください"
      end
    else
      flash.now[:alert] = "メッセージ送信に失敗しました。"
    end
    redirect_to room_path(@message.room_id)
  end
end
