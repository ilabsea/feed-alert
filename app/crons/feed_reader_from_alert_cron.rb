class FeedReaderFromAlertCron < CronBase

  def perform(*args)
    Rails.logger.info "running FeedReaderFromAlertCron"
    FeedReader.from_alert
    Rails.logger.info "finish running FeedReaderFromAlertCron"
  end

end