class ProcessFeedEntryUrl
  def initialize(feed_entry_id)
    @feed_entry_id = feed_entry_id
  end

  def run
    feed_entry = FeedEntry.find @feed_entry_id

    if feed_entry.fingerprint.blank?
      feed_entry.content = FetchPage.new(feed_entry.url).run
      feed_entry.save!
    end
  end
end