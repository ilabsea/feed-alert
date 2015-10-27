FactoryGirl.define do
  factory :group_message do
    user nil
	receiver_groups nil
	message "MyString"
  end
end
