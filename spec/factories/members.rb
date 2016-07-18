# == Schema Information
#
# Table name: members
#
#  id          :integer          not null, primary key
#  full_name   :string(255)
#  email       :string(255)
#  phone       :string(255)
#  email_alert :boolean
#  sms_alert   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

FactoryGirl.define do
  factory :member do
    sequence(:full_name) {|n| "#{FFaker::Number.number}-#{n}"}
    sequence(:email) {|n| "#{Faker::Number.number}-#{n}"}
    phone "012999888"
    email_alert true
    sms_alert true
  end

end
