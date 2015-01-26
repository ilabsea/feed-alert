FactoryGirl.define do
  factory :user do
    full_name "Admin"
    phone "0975553553"
    sequence(:email){ |n| "admin-#{n}@ilabsea.org"}
    sequence(:user_name){ |n| "admin-#{n}"}
    password "password"
    role User::ROLE_ADMIN
  end

  factory :normal_user, class: User do
    full_name "member"
    phone "0975553553"
    sequence(:email) {|n| "normal-#{n}@ilabsea.org"}
    sequence(:user_name){|n| "normal-#{n}"}
    password 'password'
    role User::ROLE_NORMAL
  end
end
