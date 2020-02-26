class AlertDigest
  def initialize(email, alert_ids)
    @email = email
    @alert_ids = alert_ids
  end

  def run
    results = []
    alerts = Alert.where(id: @alert_ids)

    alerts.each do |alert|
      alert_snapshot = get_alert_snapshot(alert.id)
      results << alert_snapshot if alert_snapshot.present?
    end

    alert_email(@email, results) if results.present?
  end

  def get_alert_snapshot(alert_id)
    alert_snapshot = {}
    snapshots = []

    alerts = Alert.where(id: alert_id)
    @search_result = FeedEntry.result(SearchOption.for_new_email_feed_entries(alerts))
    feed_entries = @search_result.feed_entries
    FeedEntry.mark_as_email_alerted(feed_entries) if !feed_entries.empty?

    @search_result.alerts.each do |alert|
      result = @search_result.results_by_alert(alert_id)
      if result.present?
        snapshots << result
      end
    end

    if snapshots.any?
      alert_snapshot = {
        alert_id: alert_id,
        snapshots: snapshots
      }
    end

    alert_snapshot
  end

  def alert_email(email, snapshots)
    AlertMailer.notify_matched(email, snapshots) if snapshots.present?
  end

  def delay_time
    ENV['DELAY_DELIVER_IN_MINUTES'].to_i
  end
end
