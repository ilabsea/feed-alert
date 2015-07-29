class ProcessFeedEntryUrlJob < ActiveJob::Base
  queue_as :lowest_priority

  def perform(feed_entry_id)
    ProcessFeedEntryUrl.new(feed_entry_id).run
  end
end
