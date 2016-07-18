module Messages
  class MessageBuilderAdapter
    def initialize message_builder
      @message_builder = message_builder
    end

    def build
      raise Errors::UnknownChannelException.new(@message_builder) if suggested_channel.nil?

      messages = []

      @message_builder.receivers.each do |receiver|
        channel = suggested_channel.suggested receiver

        if channel
          message = Message.new(Tel.new(receiver).with_country_code, @message_builder.message, channel)
          messages << message
        end
      end

      messages
    end

    def suggested_channel
      @message_builder.channel_suggested
    end
  end
end
