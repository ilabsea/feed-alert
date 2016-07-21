module Messages::Builder
  class GroupMessageBuilder < MessageBuilder
    def channel_suggested
      channel_accessible = Channels::Accessible::UserChannelAccessible.new(object)
      Channels::ChannelSuggested.new(channel_accessible)
    end
  end
end
