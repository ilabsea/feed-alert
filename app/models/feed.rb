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

class Feed < ActiveRecord::Base
  belongs_to :alert
  after_destroy :destroy_feed_entries

  def self.process_with options
    feed = Feed.where(alert_id: options[:alert_id]).first_or_initialize
    feed.update_attributes(options)
    feed
  end

  def destroy_feed_entries
    FeedEntry.remove(feed_id: self.id)
  end

end













