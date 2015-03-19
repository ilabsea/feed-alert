class FeedEntrySearch
  extend ActiveSupport::Concern

  module ClassMethods
    def search(date_range)
      feed_entries = self.includes(:alert).where(['created_at BETWEEN ? AND ? ', date_range.from, date_range.to])
      
    end
  end
end