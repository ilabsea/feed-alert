class FeedEntry < ActiveRecord::Base
  belongs_to :alert
  belongs_to :feed

  validates :title, uniqueness: { scope: :feed_id }

  before_save :set_ref_attributes
  after_create :process_url

  def set_ref_attributes
    self.fingerprint = Digest::MD5.hexdigest(self.content) unless self.content.blank?
    self.keywords = self.alert.keywords.map(&:name)
  end

  def self.process_with options
    feed_entry = FeedEntry.where(options).first_or_initialize
    feed_entry.update_attributes(options)
    feed_entry
  end

  def process_url
    ProcessFeedEntryUrlJob.set(wait: 1.minutes).perform_later(self.id)
  end

end
