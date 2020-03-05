FactoryGirl.define do
  factory :keyword_set do
    sequence(:name) {|n| "#{Faker::Name.name}-#{n}" }
    keyword "#{Faker::Name.name},#{Faker::Name.name}"
  end

end
