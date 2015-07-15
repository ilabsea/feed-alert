class FeedReader
  def self.from_alert
    alerts = Alert.includes(:keywords).all

    readers = Feedjira::Feed.fetch_and_parse(alerts.map(&:url))

    readers.each do |feed_url, reader|
      alert = alerts.select{|alert| alert.url == feed_url }.first
      if reader.class.to_s.include?("Feedjira::Parser::")
        Feed.evaluate_for(alert, reader)
      else
        Rails.logger.debug { "alert: #{alert.name} with url: #{alert.url} could not be read with error: #{reader.class}" }
      end
    end
  end
end