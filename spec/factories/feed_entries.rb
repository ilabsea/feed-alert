FactoryGirl.define do
  factory :feed_entry do
    title "MyString"
    url "MyString"
    published_at "2015-03-19 14:44:50"
    summary "MyText"
    content "MyText"
    alert
    feed
  end

end
