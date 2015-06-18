module ChannelsHelper
  def channel_active(channel, type)
    channel.setup_flow == type ? '' : 'display:none;'
  end

end