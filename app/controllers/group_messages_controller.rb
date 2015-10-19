class GroupMessagesController < ApplicationController

  def index
    
  end
  
  def new
    @group_message = GroupMessage.new
  end

  def create
    @group_message = GroupMessage.new(filter_params)
    @group_message.user_id = current_user.id
    if @group_message.save
      redirect_to group_messages_path, notice: 'Group message has been created'
    else
      flash.now[:alert] = "Failed to create group message"
      render :new
    end
  end

  private
  def filter_params
    params.require(:group_message).permit(:message, receiver_groups: [])
  end
end