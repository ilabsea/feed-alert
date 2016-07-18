module Messages::Builder
  class GroupMessageBuilder < MessageBuilder
    def initialize message, receivers, user
      super message, receivers
      @user = user
    end

    def channel_suggested
      channel_accessible = Channels::Accessible::UserChannelAccessible.new(@user)
      Channels::ChannelSuggested.new(channel_accessible)
    end
  end
end
