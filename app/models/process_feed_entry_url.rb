class ProcessFeedEntryUrl
  def initialize(feed_entry_id)
    @feed_entry_id = feed_entry_id
  end

  def run
    feed_entry = FeedEntry.find @feed_entry_id
    keywords1 = FeedEntry::KEYWORDS.shuffle
    keywords2 = ['jquery', 'php', 'ruby', 'rubyonrails', 'erlang', 'framework', 'algorith', 'passenger', 'apache', 'free', 'opensource',
      'instedd', 'ilab', 'share', 'environment', 'best practise'
    ].shuffle

    if feed_entry.has_no_content?
      feed_entry.content = FetchPage.new(feed_entry).run
      feed_entry.keywords = keywords1[0..3] if feed_entry.alert.id == 1
      feed_entry.keywords = keywords2[0..3] if feed_entry.alert.id == 2
      #feed_entry.alert.keywords.map(&:name)
      feed_entry.apply_search if feed_entry.keywords.length >0
      feed_entry.save!
    end
  end
end