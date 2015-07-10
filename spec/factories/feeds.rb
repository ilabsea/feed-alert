# == Schema Information
#
# Table name: feeds
#
#  id                 :integer          not null, primary key
#  url                :string(255)
#  title              :string(255)
#  description        :text(65535)
#  alert_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  feed_entries_count :integer          default(0)
#

FactoryGirl.define do
  factory :feed do
    url "http://rss.cnn.com/rss/edition_asia.rss"
    alert
  end

end
