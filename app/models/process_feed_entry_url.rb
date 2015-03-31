class ProcessFeedEntryUrl
  def initialize(feed_entry_id)
    @feed_entry_id = feed_entry_id
  end

  def run
    feed_entry = FeedEntry.find @feed_entry_id
    if feed_entry.has_no_content?
      feed_entry.content = FetchPage.new(feed_entry).run
      feed_entry.keywords = feed_entry.alert.keywords.map(&:name)
      feed_entry.apply_search if feed_entry.keywords.length >0
      feed_entry.save!
    end
  end
end