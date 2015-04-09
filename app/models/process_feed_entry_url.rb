class ProcessFeedEntryUrl
  def initialize(feed_entry_id)
    @feed_entry_id = feed_entry_id
  end

  def run
    feed_entry = FeedEntry.find @feed_entry_id
    feed_entry.content = FetchPage.instance.run(feed_entry.url)
    feed_entry.keywords = feed_entry.alert.keywords.map(&:name)
    feed_entry.save!
  end
end