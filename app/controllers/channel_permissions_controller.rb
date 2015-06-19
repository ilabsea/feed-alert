class ChannelPermissionsController < ApplicationController
  def create
    permission = PerformChannelPermission.new(current_user).for_channel(params)
    head :ok
  end
end