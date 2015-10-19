class GroupMessageResult

  def initialize(group_message)
    @group_message = group_message
  end

  def run
    members = Group.unique_members(@group_message.receiver_groups)
    members.each do |member|
      smses_to  << member.phone
      if smses_to.length > 0
        smses_to.each do |sms|
          options = { from: ENV['APP_NAME'],
                      to: "sms://#{sms}",
                      body: @group_message.message,
                      suggested_channel: nil
                    }

          SmsAlertJob.set(wait: delay_time.minute).perform_later(options)
        end
      end

    end
  end

end