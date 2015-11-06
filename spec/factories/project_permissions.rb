FactoryGirl.define do
  factory :project_permission do
    user nil
    project nil
    role "MyString"
  end
end