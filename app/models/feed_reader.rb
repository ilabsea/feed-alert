class FeedReader
  def self.from_alert
    Alert.valid_url.order('id DESC').where("alert_keywords_count > ?", 0).select('id').find_each(batch_size: 10).each do |alert|
      next if ProcessFeedJob.is_job_running?(alert.id)
      ProcessFeedJob.set(wait: 10.seconds).perform_later(alert.id)
    end
  end
end