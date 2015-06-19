class ChannelsController < ApplicationController
  def index
    @my_channels = current_user.channels
    @shared_channels = current_user.shared_channels.includes(:channel_permissions)
  end

  def new
    @channel = current_user.channels.build
  end

  def create
    @channel = current_user.channels.build(filter_params)
    begin 
      if @channel.save
        redirect_to channels_path, notice: 'Channel has been created'
      else
        flash.now[:alert] = 'Failed to create channel'
        render :new
      end
    rescue Nuntium::Exception
      @channel.destroy if @channel.persisted?
      redirect_to channels_path, alert: 'Failed to sync with Nuntium server'
    end
  end

  def edit
    @channel = current_user.channels.find(params[:id])
  end

  def update
    @channel_with_role = current_user.accessible_channel(params[:id])
    @channel_with_role.has_admin_role!

    if @channel_with_role.update_attributes(filter_params)
      redirect_to channels_path, notice: 'Channel has been updated'
    else
      flash.now[:alert] = 'Failed to update channel'
      render :edit
    end
  end

  def destroy
    begin
      @channel_with_role = current_user.accessible_channel(params[:id])
      @channel_with_role.has_admin_role!

      @channel_with_role.destroy
      redirect_to channels_path, notice: 'Channel deleted'
    rescue
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