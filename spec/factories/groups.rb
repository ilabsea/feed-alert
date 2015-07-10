# == Schema Information
#
# Table name: groups
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

FactoryGirl.define do
  factory :group do
    sequence(:name) {|n| "#{Faker::Number.name}-#{n}"}
    sequence(:description) {|n| "#{Faker::Number.name}-#{n}"}
  end

end
