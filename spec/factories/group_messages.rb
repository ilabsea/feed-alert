FactoryGirl.define do
  factory :group_message do
    user nil
  	receiver_groups nil
  	message "MyString"
    email_alert false
    sms_alert false
  end
end
