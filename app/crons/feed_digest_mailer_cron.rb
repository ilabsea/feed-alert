class FeedDigestMailerCron < CronBase

  def perform(*args)
    Rails.logger.info "running FeedDigestMailerCron"
    FeedReader.digest_feed
    Rails.logger.info "finish running FeedDigestMailerCron"
  end

end