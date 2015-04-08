class FeedEntry < ActiveRecord::Base
  serialize :keywords, JSON

  include FeedEntrySearch

  belongs_to :alert
  belongs_to :feed

  validates :title, uniqueness: { scope: :feed_id }

  before_save :invoke_fingerprint
  after_create :process_url

  include Elasticsearch::Model

  index_name    "feed_entry-#{Rails.env}"
  document_type "feed_entry"

  settings index: { number_of_shards: 1 } do
    mappings do
      indexes :title, analyzer: 'english', index_options: 'offsets'
      indexes :summary, analyzer: 'english', index_options: 'offsets'
      indexes :content, type: 'attachment', fields: { 
                                                      author: { index: "no"},
                                                      date: { index: "no"},
                                                      content: { store: "yes",
                                                                 type: "string",
                                                                 term_vector: "with_positions_offsets"
                                                              }
                                                    }
    end
  end

  after_commit lambda { IndexerJob.perform_later('index',  self.class.to_s, self.id) }, on: :create
  after_commit lambda { IndexerJob.perform_later('update', self.class.to_s, self.id) }, on: :update
  after_commit lambda { IndexerJob.perform_later('delete', self.class.to_s, self.id) }, on: :destroy
  after_touch  lambda { IndexerJob.perform_later('update', self.class.to_s, self.id) }

  # Util for creating index
  def self.create_index
    options = {
      index: FeedEntry.index_name,
      body: { settings: FeedEntry.settings.to_hash,
              mappings: FeedEntry.mappings.to_hash
            }
    }
    FeedEntry.__elasticsearch__.client.indices.create(options)
  end

  def self.update_index
    FeedEntry.__elasticsearch__.create_index! force: true
    FeedEntry.__elasticsearch__.refresh_index!
  end

  def as_indexed_json(options={})
    hash = self.as_json
    hash["content"] = {
      "_detect_language": false,
      "_language": "en",
      "_indexed_chars": -1 ,
      # "_content_type": "text/html",
      "_content": Base64.encode64(self.content)
    }
    hash
  end

  def self.search(query)
    criterias = {
        query: {
          bool: {
            should: [
               {terms: { title: query } },
               {terms: { content: query } },
               {terms: { summary: query } },
            ]
          }
        },
        highlight: {
          pre_tags: ['<em class="label label-highlight">'],
          post_tags: ['</em>'],
          fields: {
            title:   { fragment_size: 200 },
            summary:  { fragment_size: 200 },
            content: { fragment_size: 200 }
          }
        }
      }

    __elasticsearch__.search(criterias)
  end

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
