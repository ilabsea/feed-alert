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

FactoryGirl.define do
  factory :alert_keyword do
    alert
    keyword
  end

end
