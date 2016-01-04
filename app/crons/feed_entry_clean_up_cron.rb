class FeedEntryCleanUpCron < CronBase

  def perform(*args)
    FeedEntry.remove_unmatched_for(2.days.ago)
  end

end