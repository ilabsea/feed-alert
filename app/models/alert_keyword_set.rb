# == Schema Information
#
# Table name: alert_keyword_sets
#
#  id             :integer          not null, primary key
#  alert_id       :integer
#  keyword_set_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class AlertKeywordSet < ActiveRecord::Base
  belongs_to :alert, touch: true
  belongs_to :keyword_set

  validates :alert_id, presence: true, uniqueness: { scope: :keyword_set_id }
  validates :keyword_set_id, presence: true
end
