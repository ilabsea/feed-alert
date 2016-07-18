module Messages::Builder
  class MessageBuilder
    attr_reader :message, :receivers

    def initialize message, receivers = []
      @message = message
      @receivers = receivers
    end
  end
end
