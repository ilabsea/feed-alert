class ChannelsController < ApplicationController
  def index
    @my_channels     = current_user.channels
                                   .page(params[:page])

    @channel_permissions = current_user.channel_permissions
                                   .includes(:channel)
                                   .page(params[:shared_page])
  end

  def new
    @channel = current_user.channels.build
  end

  def create
    @channel = current_user.channels.build(filter_params)
    @channel.name = @channel.ticket_code
    @channel.is_enable = true

    channel_nuntium = ChannelNuntium.new(@channel)
    if channel_nuntium.create
      current_user.channels.disable_other(@channel.id)
      render json: channel_nuntium, status: 200
    else
      render json: channel_nuntium.error_message, status: 400, :layout => false
    end
  end

  def destroy
    @channel_with_role = current_user.accessible_channel(params[:id])
    @channel_with_role.has_admin_role!

    channel = @channel_with_role.object
    channel_nuntium = ChannelNuntium.new(channel)

    if channel_nuntium.delete
      redirect_to channels_path, notice: 'Channel has been deleted'
    else
      redirect_to channels_path, alert: 'Failed to delete channel'
    end
  end

  def state
    @channel_with_role = current_user.accessible_channel(params[:id])
    @channel_with_role.has_admin_role!
    @channel_with_role.object.update_state(params[:state])
    head :ok
  end

  private

  def filter_params
    params.require(:channel).permit(:name, :password, :ticket_code, :setup_flow)
  end
end