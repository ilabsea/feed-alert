module FeedEntrySearch
  def apply_search
    self.matched = StringSearch.new(self.content).match_keywords?(self.keywords)
  end
end