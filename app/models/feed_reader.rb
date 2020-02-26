class FeedReader
  class << self
    def from_alert
      Alert.valid.select('id').find_each(batch_size: 10).each do |alert|
        next if ProcessFeedJob.is_job_running?(alert.id)
        ProcessFeedJob.set(wait: 10.seconds).perform_later(alert.id)
      end
    end

    def digest_feed
      feeds = FeedEntry.where(email_alerted: false)
      receiver = generate_alert_emails(feeds)
      AlertDigestJob.set(wait: 10.seconds).perform_later(receiver)
    end

    private
      def generate_alert_emails(feeds)
        alert_ids = feeds.collect(&:alert_id).uniq
        alerts = Alert.where(id: alert_ids)

        receiver = {};
        alerts.each do |alert|
          members = alert.members.where(email_alert: true)
          members.each do |member|
            receiver[member.email] = [] if receiver[member.email].nil?
            receiver[member.email] << alert.id
          end
        end

        receiver
      end
  end
end
