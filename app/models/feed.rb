class Feed < ActiveRecord::Base
  belongs_to :alert
  has_many :feed_entries, dependent: :destroy

  def self.evaluate_for(alert, reader)
    feed_attrs = {
       title: reader.title,
       description: reader.description,
       url: reader.feed_url,
       alert_id: alert.id
    }

    feed = Feed.process_with(feed_attrs)

    reader.entries.each do |reader_entry|
      entry_attrs = {
        title: reader_entry.title,
        url: reader_entry.url,
        published_at: reader_entry.published,
        summary: reader_entry.summary,
        alert_id: alert.id,
        feed_id: feed.id
      }
      FeedEntry.process_with(entry_attrs)
    end
  end

  def self.process_with options
    feed = Feed.where(options).first_or_initialize
    feed.update_attributes(options)
    feed
  end
end













