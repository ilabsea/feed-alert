class AlertDigest
  def initialize(email, alert_ids)
    @email = email
    @alert_ids = alert_ids
  end

  def run
    results = []
    alerts = Alert.where(id: @alert_ids)

    alerts.each do |alert|
      results << get_alert_snapshot(alert.id)
    end
    byebug
    # alert_email(email, results)
  end

  def get_alert_snapshot(alert_id)
    alert_snapshot = {
      alert_id: alert_id,
      snapshot: []
    }

    alerts = Alert.where(id: alert_id)

    @search_result = FeedEntry.result(SearchOption.for_new_feed_entries(alerts))
    feed_entries = @search_result.feed_entries
    # FeedEntry.mark_as_email_alerted(feed_entries) if !feed_entries.empty?

    @search_result.alerts.each do |alert|
      # result = alert_highlight(alert.id)
      result = @search_result.results_by_alert(alert_id)
      if !result.empty?
        alert_snapshot[:snapshot] << result
      end
    end

    alert_snapshot
  end

  def alert_email(email, snapshots)
    AlertMailer.delay_for(delay_time.minute).notify_matched(email, snapshots) if snapshots.present?
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