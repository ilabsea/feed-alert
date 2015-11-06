# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  password   :string(255)
#  setup_flow :string(255)
#  is_enable  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :channel, class: Channel do
    sequence(:name) { |n| "channel-#{n}"}
	user nil
	password "MyString"
	setup_flow "MyString"
	is_enable false
  end

  factory :basic_channel, class: Channel do
    sequence(:name) { |n| "basic_channel-#{n}"}
	user nil
	password "MyString"
	setup_flow "#{Channel::SETUP_FLOW_BASIC}"
	is_enable false
	ticket_code "MyString"
  end

  factory :advance_channel, class: Channel do
    sequence(:name) { |n| "advance_channel-#{n}"}
	user nil
	password "mypass"
	setup_flow "#{Channel::SETUP_FLOW_ADVANCED}"
	is_enable false
  end

  factory :national_channel, class: Channel do
    sequence(:name) { |n| "national_channel-#{n}"}
	user nil
	password "MyString"
	setup_flow "#{Channel::SETUP_FLOW_GLOBAL}"
	is_enable false
  end

end
