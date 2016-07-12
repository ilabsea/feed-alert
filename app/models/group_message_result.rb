class GroupMessageResult
  def initialize(group_message, channels)
    @group_message = group_message
    @channels = channels
  end

  def run
    delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i
    messages = []
    smses_to = []
    emails_to = []

    groups = Group.where(id: @group_message.receiver_groups)
    channel_suggested = ChannelSuggested.new(@channels)

    groups.each do |group|
      smses_to = []
      group.members.each do |member|
        emails_to << member.email
        smses_to  << member.phone
      end
      if smses_to.length > 0
        smses_to.each do |sms|
          suggested_channel = channel_suggested.by_phone sms
          if suggested_channel
            options = { from: ENV['APP_NAME'],
                        to: "sms://#{sms}",
                        body: @group_message.message,
                        suggested_channel: suggested_channel.name
                      }
            messages = messages.push options
          end

        end
      end
    end
    AlertMailer.delay_for(delay_time.minute).notify_group_message(@group_message, emails_to) if @group_message.email_alert
    SmsAlertJob.set(wait: delay_time.minute).perform_later(messages) if @group_message.sms_alert
  end

  def parse
    messages = []
    groups = Group.where(id: @group_message.receiver_groups)
    channel_suggested = ChannelSuggested.new(@channels)
    groups.each do |group|
      smses_to = []
      emails_to = []
      group.members.each do |member|
        emails_to << member.email
        smses_to  << member.phone
      end
      if smses_to.length > 0
        smses_to.each do |sms|
          suggested_channel = channel_suggested.by_phone sms
          if suggested_channel
            options = { from: ENV['APP_NAME'],
                        to: "sms://#{sms}",
                        body: @group_message.message,
                        suggested_channel: suggested_channel.name
                      }
            messages = messages.push options
          end

        end
      end
    end
    messages
  end

end
