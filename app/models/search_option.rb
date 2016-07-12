class SearchOption

  def self.for_new_feed_entries(alerts)
    self.for(alerts, false)
  end

  def self.for_old_feed_entries(alerts)
    self.for(alerts, true)
  end

  def self.for(alerts, alerted )
    options = {}
    options[:q] = alerts.map {|alert| { id: alert.id, keywords: alert.keywords.map(&:name) } }
    options[:alerted] = alerted
    options
  end
end
