class FeedReader
  def self.from_alert
    alerts = Alert.includes(:keywords).all

    readers = Feedjira::Feed.fetch_and_parse(alerts.map(&:url))
    readers.each do |feed_url, reader|
      alert = alerts.select{|alert| alert.url = feed_url }.first
      Feed.evaluate_for(alert, reader)
    end
  end
end