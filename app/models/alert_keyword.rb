class AlertKeyword < ActiveRecord::Base
  belongs_to :alert, counter_cache: true
  belongs_to :keyword
end
