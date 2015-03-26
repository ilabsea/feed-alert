module AlertMatchCriteria
  extend ActiveSupport::Concern

  module ClassMethods
    def matched date_range
      Alert.includes(:feed_entries)
           .joins(:feed_entries)
           .merge(FeedEntry.matched.between(date_range))
           .uniq
    end
  end

end