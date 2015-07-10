# == Schema Information
#
# Table name: alert_places
#
#  id         :integer          not null, primary key
#  alert_id   :integer
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AlertPlace < ActiveRecord::Base
  belongs_to :alert, counter_cache: true
  belongs_to :place
end
