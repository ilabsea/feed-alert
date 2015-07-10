# == Schema Information
#
# Table name: alert_keywords
#
#  id         :integer          not null, primary key
#  alert_id   :integer
#  keyword_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AlertKeyword < ActiveRecord::Base
  belongs_to :alert, counter_cache: true
  belongs_to :keyword
end
