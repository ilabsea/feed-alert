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

  belongs_to :alert
  belongs_to :feed, counter_cache: true

  # validates :title, uniqueness: { scope: :feed_id }

  before_save :invoke_fingerprint
  after_create :process_url

  def self.matched
    where(matched: true)
  end

  def self.between date_range
    where(['feed_entries.created_at BETWEEN ? AND ?', date_range.from, date_range.to])
  end

  def invoke_fingerprint
    self.fingerprint = Digest::MD5.hexdigest(self.content) unless self.content.blank?
  end

  def self.process_with options
    feed_entry = FeedEntry.where(options.slice(:title, :url)).first
    FeedEntry.create(options) unless feed_entry
  end

  def process_url
    ProcessFeedEntryUrlJob.set(wait: 10.seconds).perform_later(self.id)
  end

end
