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
  factory :channel do
    name "MyString"
user nil
password "MyString"
setup_flow "MyString"
is_enable false
  end

end
