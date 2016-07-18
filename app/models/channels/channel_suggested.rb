module Channels
  class ChannelSuggested
    def initialize channel_accessible
      @channel_accessible = channel_accessible
    end

    def suggested phone_number
      phone_carrier = Tel.new(phone_number).carrier
      channels = @channel_accessible.list

      channels.each do |channel|
        return channel if channel["name"] === phone_carrier
      end if phone_carrier

      channels.first
    end
  end
end
