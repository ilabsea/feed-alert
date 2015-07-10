# == Schema Information
#
# Table name: group_permissions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  group_id     :integer
#  alert_id     :integer
#  project_id   :integer
#  role         :string(255)
#  order_number :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :group_permission do
    user nil
group nil
role "MyString"
order 1
  end

end
