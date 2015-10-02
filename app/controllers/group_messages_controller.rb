class GroupMessagesController < ApplicationController

  def new
    @group_message = GroupMessage.new
  end

  def create
    @group_message = GroupMessage.new
  end

  private
  def filter_params
    params.require(:group_message).permit(:message, receivers: [])
  end
end