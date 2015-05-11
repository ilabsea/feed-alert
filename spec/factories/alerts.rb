FactoryGirl.define do
  factory :alert do
    name "MyString"
    url "MyString"
    sms_template "MyText"
    from_time "10:00"
    to_time "12:00"
  end

end
