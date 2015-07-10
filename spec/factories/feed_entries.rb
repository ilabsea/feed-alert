# == Schema Information
#
# Table name: feed_entries
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  url          :string(255)
#  published_at :datetime
#  summary      :text(65535)
#  content      :text(4294967295)
#  alerted      :boolean          default(FALSE)
#  fingerprint  :string(255)
#  alert_id     :integer
#  feed_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  keywords     :text(65535)
#  matched      :boolean          default(FALSE)
#

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
