class AlertResult
  def initialize(alerts)
    @alerts = alerts
    @search_result = nil
  end

  def run
    @search_result = FeedEntry.result(SearchOption.for_new_feed_entries(@alerts))
    feed_entries = @search_result.feed_entries
    FeedEntry.mark_as_alerted(feed_entries) if !feed_entries.empty?

    @search_result.alerts.each do |alert|
      result = alert_highlight(alert.id)
      if !result.empty?
        alert_sms(alert)
      end
    end
  end

  def alert_sms alert
    alert.groups.each do |group|
      if alert.has_match? && alert.project.time_appropiate?(Time.zone.now)
        messages = messages_of(alert.translate_message, receivers_of(group, :sms), alert.project).map { |message| message.to_nuntium_params }
        SmsAlertJob.set(wait: delay_time.minute).perform_later(messages) unless messages.empty?
      end
    end
  end

  def alert_highlight alert_id
    @search_result.results_by_alert(alert_id)
  end

  def delay_time
    ENV['DELAY_DELIVER_IN_MINUTES'].to_i
  end

  def receivers_of group, type = :sms
    group.members.where("#{type}_alert" => true).pluck(type === :sms ? :phone : :email)
  end

  def messages_of message, receivers, project
    message_builder = Messages::Builder::AlertMessageBuilder.new(message, receivers, project)
    begin
      return Messages::MessageBuilderAdapter.new(message_builder).build()
    rescue Errors::UnknownChannelException => e
      Rails.logger.debug { "#{e.object}:#{e.message}" }
    end
  end

end
