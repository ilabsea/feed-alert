class FeedEntry < ActiveRecord::Base
  serialize :keywords, JSON
  include FeedEntrySearch

  belongs_to :alert
  belongs_to :feed

  KEYWORDS = ['virus', 'disease', 'west', 'africa', 'transmission', 'outbreak', 'spread', 'public health',
     'hygiene',  'preventive', 'behavior', 'Risk', 'threat', 'sex', 'education', 'vaccination', 'epidemic', 'influenza',
     'emerging', 'misinformation', 'patients', 'hospitals', 'healthcare', 'hiv', 'malaria', 'aid', 'Infection'
  ]

  validates :title, uniqueness: { scope: :feed_id }

  before_save :invoke_fingerprint
  after_create :process_url

  def has_no_content?
    self.content.blank?
  end

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
    feed_entry = FeedEntry.where(options).first_or_initialize
    feed_entry.update_attributes(options)
    feed_entry
  end

  def process_url
    ProcessFeedEntryUrlJob.set(wait: 10.seconds).perform_later(self.id)
  end

end
