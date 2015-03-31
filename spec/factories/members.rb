FactoryGirl.define do
  factory :member do
    sequence(:full_name) {|n| "#{Faker::Number.number}-#{n}"}
    sequence(:email) {|n| "#{Faker::Number.number}-#{n}"}
    phone "012999888"

    email_alert true
    sms_alert true
  end

end
