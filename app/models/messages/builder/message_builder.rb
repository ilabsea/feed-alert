module Messages::Builder
  class MessageBuilder
    attr_reader :message, :receivers, :object

    def initialize message, receivers = [], object = nil
      @message = message
      @receivers = receivers
      @object = object
    end
  end
end
