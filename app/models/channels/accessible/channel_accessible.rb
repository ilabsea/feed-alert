module Channels::Accessible
  class ChannelAccessible
    attr_reader :object
    
    def initialize object
      @object = object
    end

    def list
    end
  end
end
