class AlertKeywordSet < ActiveRecord::Base
  belongs_to :alert, counter_cache: true, touch: true
  belongs_to :keyword_set
end
