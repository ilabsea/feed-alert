class AlertGroup < ActiveRecord::Base
  belongs_to :alert, counter_cache: true
  belongs_to :group
end
