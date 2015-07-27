class FeedEntryCleanUpCron < CronBase

  def perform(*args)
    Rails.logger.info "Running feed entry clean up"
    FeedEntry.where(['updated_at < ?', 1.month.ago]).destroy_all
    Rails.logger.info "Rinish running FeedEntryCleanUpCron"
  end

end