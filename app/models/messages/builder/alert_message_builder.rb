module Messages::Builder
  class AlertMessageBuilder < MessageBuilder
    def channel_suggested
      channel_accessible = Channels::Accessible::ProjectChannelAccessible.new(object)
      Channels::ChannelSuggested.new(channel_accessible)
    end
  end
end
