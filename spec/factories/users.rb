FactoryGirl.define do
  factory :admin_user, class: User do
    full_name "Admin"
    sequence(:phone) {|n| "0102222-#{n}"}
    sequence(:email) { |n| "admin-#{n}@ilabsea.org"}
    password "password"
    role User::ROLE_ADMIN
  end

  factory :user, class: User do
    full_name "member"
    sequence(:phone) {|n| "0115555-#{n}"}
    sequence(:email) {|n| "normal-#{n}@ilabsea.org"}
    password 'password'
    role User::ROLE_NORMAL
  end
end
