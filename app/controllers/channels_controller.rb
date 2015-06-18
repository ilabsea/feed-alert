class ChannelsController < ApplicationController
  def index
    @channels = current_user.channels
  end

  def new
    @channel = current_user.channels.build
  end

  def create
    @channel = current_user.channels.build(filter_params)

    if @channel.save
      redirect_to channels_path, notice: 'Channel has been created'
    else
      flash.now[:alert] = 'Failed to create channel: ' + @channel.errors.full_messages.first
      render :new
    end
  end

  def edit
    @channel = current_user.channels.find(params[:id])
  end

  def update
    @channel = current_user.channels.find(params[:id])
    if @channel.update_attribute(filter_params)
      redirect_to channels_path, notice: 'Channel has been updated'
    else
      flash.now[:alert] = 'Failed to update channel: ' + @channel.errors.full_messages.first
      render :edit
    end
  end

  def destroy
    @channel = current_user.channels.find(params[:id])
    @channel.destroy
    redirect_to channels_path, notice: 'Channel deleted'
  end

  def state
    channel = current_user.channels.find(params[:id])
    channel.is_enable = params[:state]
    channel.save
    head :ok
  end

  private

  def filter_params
    params.require(:channel).permit(:name, :password, :ticket_code, :setup_flow)
  end

end