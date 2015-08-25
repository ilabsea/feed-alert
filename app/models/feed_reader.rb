class FeedReader
  def self.from_alert
    Alert.select('id').order('id DESC').find_each(batch_size: 10).each do |alert|
      ProcessFeedJob.set(wait: 1.seconds).perform_later(alert.id)
    end
  end
end