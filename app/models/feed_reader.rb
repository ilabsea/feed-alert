class FeedReader
  def self.from_alert
    alerts = Alert.includes(:keywords).all

    readers = Feedjira::Feed.fetch_and_parse(alerts.map(&:url))
    readers.each do |feed_url, reader|
      alert = alerts.select{|alert| alert.url == feed_url }.first
      if reader.class == Feedjira::Parser::RSS
        Feed.evaluate_for(alert, reader)
      else
        Rails.logger.debug { "alert: #{alert.name} with url: #{alert.url} could not be read" }
      end
    end
  end
end