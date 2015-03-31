FactoryGirl.define do
  factory :keyword do
    sequence(:name) {|n| "#{Faker::Name.name}-#{n}" }
  end

end
