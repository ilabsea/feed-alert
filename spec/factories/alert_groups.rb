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

FactoryGirl.define do
  factory :alert_group do
    alert
    group
  end

end
