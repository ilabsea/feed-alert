class AlertResult
  def initialize(alerts)
    @alerts = alerts
  end

  def run
    search_result = FeedEntry.search(SearchOption.for_new_feed_entries(@alerts))
    FeedEntry.mark_as_alerted(search_result.feed_entries)

    delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i

    search_result.alerts.each do |alert|
      alert_email(alert)
      alert_sms(alert)
    end
  end

  private
  def alert_email alert
    alert.groups.each do |group|
      emails_to = []
      smses_to  = []

      group.members.each do |member|
        emails_to << member.email if member.email_alert
        smses_to  << member.phone if member.sms_alert && alert.project.enabled_channels
      end

      if emails_to.length > 0 && alert.total_match > 0

        # delay, delay_for, delay_unitl
        AlertMailer.delay_for(delay_time.minute).notify_matched(search_result.results_by_alert(alert.id),
                                   alert.id,
                                   group.name,
                                   emails_to)
      end
    end
  end

  def alert_sms alert
    alert.groups.each do |group|
      smses_to  = []
      sms_time = Time.zone.now

      group.members.each do |member|
        smses_to  << member.phone if member.sms_alert && alert.project.enabled_channels
      end

      if smses_to.length > 0 && alert.total_match > 0 && alert.project.is_time_appropiate?(sms_time)
        active_channels = ChannelNuntium.active_channels(alert.project.enabled_channels)
        channel_suggested = ChannelSuggested.new(active_channels)

        message_body = alert.translate_message
        message_options = []
        smses_to.each do |sms|
          suggested_channel = channel_suggested.by_phone(sms)
          if suggested_channel
            options = { from: ENV['APP_NAME'],
                        to: "sms://#{sms}",
                        body: message_body,
                        suggested_channel: suggested_channel.name
                      }
            message_options << options
          end
        end
        SmsAlertJob.set(wait: delay_time.minute).perform_later(message_options) if !message_options.empty?
      end
    end
  end

end