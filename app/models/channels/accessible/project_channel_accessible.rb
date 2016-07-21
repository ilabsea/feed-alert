module Channels::Accessible
  class ProjectChannelAccessible < ChannelAccessible
    def list
      active_channels = []

      object.enabled_channels.each do |channel|
        if channel.is_enable && ChannelNuntium.new(channel).client_connected
          active_channels.push channel
        end
      end

      active_channels
    end
  end
end
