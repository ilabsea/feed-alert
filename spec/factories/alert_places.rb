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

FactoryGirl.define do
  factory :alert_place do
    alert
    place
  end

end
