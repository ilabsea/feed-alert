FactoryGirl.define do
  factory :group do
    sequence(:name) {|n| "#{Faker::Number.name}-#{n}"}
    sequence(:description) {|n| "#{Faker::Number.name}-#{n}"}
  end

end
