class AlertGroup < ActiveRecord::Base
  belongs_to :alert, counter_cache: true
  belongs_to :group

  validates :alert_id, :group_id, presence: true
end
