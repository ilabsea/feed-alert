class GroupMessageResult

  def initialize(group_message)
    @group_message = group_message
  end

  def run
    delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i
    messages = []
    emails_to = []

    groups = Group.where(id: @group_message.receiver_groups).includes(:members)

    groups.each do |group|
      smses_to = []

      group.members.each do |member|
        emails_to << member.email if @group_message.email_alert
        smses_to  << member.phone if @group_message.sms_alert
      end
      messages.concat(messages_of(smses_to).map { |sms| sms.to_nuntium_params })
    end

    AlertMailer.delay_for(delay_time.minute).notify_group_message(@group_message, emails_to) unless emails_to.empty?
    SmsAlertJob.set(wait: delay_time.minute).perform_later(messages) if @group_message.sms_alert unless messages.empty?
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
