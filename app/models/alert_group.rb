# == Schema Information
#
# Table name: alert_groups
#
#  id         :integer          not null, primary key
#  alert_id   :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AlertGroup < ActiveRecord::Base
  belongs_to :alert, counter_cache: true, touch: true
  belongs_to :group

  validates :alert_id, :group_id, presence: true
end
