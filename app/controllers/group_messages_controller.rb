class GroupMessagesController < ApplicationController

  def index
    
  end
  
  def new
    @group_message = GroupMessage.new
  end

  def create
    @group_message = GroupMessage.new(filter_params)
    @group_message.user_id = current_user.id
    if @group_message.send_ao
      redirect_to new_group_message_path, notice: 'Group message has been send'
    else
      flash.now[:alert] = "Failed to send group message"
      render :new
    end
  end

  private
  def filter_params
    params.require(:group_message).permit(:message, :email_alert, :sms_alert, receiver_groups: [])
  end
end