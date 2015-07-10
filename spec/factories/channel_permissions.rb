# == Schema Information
#
# Table name: channel_permissions
#
#  id         :integer          not null, primary key
#  channel_id :integer
#  user_id    :integer
#  role       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :channel_permission do
    channel nil
user nil
role "MyString"
  end

end
