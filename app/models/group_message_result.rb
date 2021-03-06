class GroupMessageResult

  def initialize(group_message)
    @group_message = group_message
  end

  def run
    delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i
    messages = []
    emails_to =  @group_message.recipients_by('email')
    smses_to = @group_message.recipients_by('phone')
    messages.concat(messages_of(smses_to).map { |sms| sms.to_nuntium_params })

    AlertMailer.delay_for(delay_time.minute).notify_group_message(@group_message, emails_to) unless emails_to.empty?
    SmsAlertJob.set(wait: delay_time.minute).perform_later(messages) unless messages.empty?
  end

  def messages_of receivers
    message_builder = Messages::Builder::GroupMessageBuilder.new(@group_message.message, receivers, @group_message.user)
    begin
      return Messages::MessageBuilderAdapter.new(message_builder).build()
    rescue Errors::UnknownChannelException => e
      Rails.logger.debug { "#{e.object}:#{e.message}" }
    end

  end

end
