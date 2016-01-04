class FeedReader
  def self.from_alert
    Alert.valid_url.select('id').order('id DESC').find_each(batch_size: 10).each do |alert|
      ProcessFeedJob.set(wait: 10.seconds).perform_later(alert.id)
    end
  end
end