class ProcessFeedEntryJob < ActiveJob::Base
  queue_as :process_feed_entry

  def perform(feed_entry_id)
    feed_entry = FeedEntry.find feed_entry_id
    if feed_entry
      ProcessFeedEntry.start(feed_entry)
    else
      Rails.logger.debug { "could not find any feed_entry with id: #{feed_entry_id}" }
    end
  end
end
