class ProcessFeedEntry
  def self.start feed_entry
    feed_entry.content = FetchPage.instance.run(feed_entry.url)
    feed_entry.keywords = feed_entry.alert.keywords.map(&:name)
    feed_entry.save!
  end
end