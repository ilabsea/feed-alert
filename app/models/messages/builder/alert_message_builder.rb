module Messages::Builder
  class AlertMessageBuilder < MessageBuilder
    def initialize message, receivers, project
      super message, receivers
      @project = project
    end

    def channel_suggested
      channel_accessible = Channels::Accessible::ProjectChannelAccessible.new(@project)
      Channels::ChannelSuggested.new(channel_accessible)
    end
  end
end
