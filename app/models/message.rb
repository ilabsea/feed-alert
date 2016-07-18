class Message
  def initialize(receiver, body, channel)
    @receiver = receiver
    @body = body
    @channel = channel
  end

  def to_nuntium_params
    { from: ENV['APP_NAME'], to: "sms://#{@receiver}", body: @body, suggested_channel: @channel.name }
  end

end
