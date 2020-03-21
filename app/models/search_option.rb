class SearchOption

  def self.for_new_feed_entries(alerts)
    self.for(alerts, false)
  end

  def self.for_old_feed_entries(alerts)
    self.for(alerts, true)
  end

  def self.for_new_email_feed_entries(alerts)
    options = {}
    options[:q] = alerts.map { |alert| { id: alert.id, keywords: alert.keyword_sets.map(&:keyword).join(",").split(",").uniq } }
    options[:email_alerted] = false
    options
  end

  def self.for(alerts, alerted)
    options = {}
    options[:q] = alerts.map {|alert| { id: alert.id, keywords: alert.keyword_sets.map(&:keyword).join(",").split(",").uniq } }
    options[:alerted] = alerted
    options
  end
end
