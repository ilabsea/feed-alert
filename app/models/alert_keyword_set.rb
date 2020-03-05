class AlertKeywordSet < ActiveRecord::Base
  belongs_to :alert, touch: true
  belongs_to :keyword_set

  validates :alert_id, presence: true, uniqueness: { scope: :keyword_set_id }
  validates :keyword_set_id, presence: true
end
