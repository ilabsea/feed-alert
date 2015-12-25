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

class FeedEntry < ActiveRecord::Base
  serialize :keywords, JSON

  include FeedEntrySearch
  include SearchQuery

  belongs_to :alert
  belongs_to :feed

  validates :title, uniqueness: { scope: :url }
  validates :fingerprint, uniqueness: true

  before_save :invoke_fingerprint
  # after_create :process_url

  def self.matched
    where(matched: true)
  end

  def self.between date_range
    where(['feed_entries.created_at BETWEEN ? AND ?', date_range.from, date_range.to])
  end

  def invoke_fingerprint
    uniqueness_attribute = self.title + self.url
    self.fingerprint = Digest::MD5.hexdigest(uniqueness_attribute)
  end


  def self.fetch_and_save options
    feed_entry = FeedEntry.where(title: options[:title]).first_or_initialize
    # prevent reindexing for feed entry with same title and url 
    # if url is still the same -> old content thus do nothing
    return false if feed_entry.persisted? && feed_entry.url == options[:url]
 
          
    options[:content] = FetchPage.instance.run(feed_entry.url)
    options[:keywords] = feed_entry.alert.keywords.map(&:name)
    feed_entry.update_attributes(options)
  end

  def self.mark_as_alerted(ids)
    #trigger feed_entry update with elastic
    FeedEntry.where(id: ids).each do |feed_entry|
      feed_entry.alerted = true
      feed_entry.save
    end
  end

  def process_url
    ProcessFeedEntryJob.perform_later(self.id)
  end

end
