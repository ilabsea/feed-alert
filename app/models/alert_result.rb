class AlertResult
  def initialize(alerts, date_range)
    @alerts = alerts
    @date_range = date_range
  end

  def run

    search_result = FeedEntry.search(Alert.search_options(@alerts, @date_range))
    delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i

    search_result.alerts.each do |alert|
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
                                     emails_to,
                                     @date_range)
        end

        sms_time = Time.zone.now

        # alert.channel is duplicated but it offers clear
        if smses_to.length > 0 && alert.total_match > 0 && alert.project.is_time_appropiate?(sms_time)
          # channel_suggested = ChannelSuggested.new(alert.project.enabled_channels)
          active_channels = ChannelNuntium.active_channels(alert.project.enabled_channels)
          channel_suggested = ChannelSuggested.new(active_channels)
          smses_to.each do |sms|
            suggested_channel = channel_suggested.by_phone(sms)
            if suggested_channel
              options = { from: ENV['APP_NAME'],
                          to: "sms://#{sms}",
                          body: alert.translate_message,
                          suggested_channel: suggested_channel.name
                        }

              SmsAlertJob.set(wait: delay_time.minute).perform_later(options)
            end
          end
        end
      end
    end
  end




end