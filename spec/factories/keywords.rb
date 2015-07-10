# == Schema Information
#
# Table name: keywords
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :keyword do
    sequence(:name) {|n| "#{Faker::Name.name}-#{n}" }
  end

end
