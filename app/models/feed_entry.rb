class FeedEntry < ActiveRecord::Base
  serialize :keywords, JSON

  include FeedEntrySearch

  belongs_to :alert
  belongs_to :feed, counter_cache: true

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

  after_commit lambda { sync_index('index') }, on: :create
  after_commit lambda { sync_index('update') }, on: :update
  after_commit lambda { sync_index('delete') }, on: :destroy

  def sync_index(action_type)
    Rails.logger.debug { "Try to sync index" }
    if action_type =='delete'
      IndexerJob.perform_later(action_type, self.class.to_s, self.id)
    elsif self.has_content?
      IndexerJob.perform_later(action_type, self.class.to_s, self.id)
    else
      Rails.logger.debug { "Index not sync for #{self.id}" }
    end
  end

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

  def self.recreate_index
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

  def self.build_criterias options
    keywords = options[:keywords]
    shoulds = []

    keywords.each do |keyword|
      match_phrase = { multi_match: {
                            query: keyword,
                            type: "phrase",
                            fields: ['title', 'summary', 'content']
                          }
                     }
      shoulds << match_phrase
    end

    highlight = {
                  fields: {
                    title: { fragment_size: 200 },
                    summary: { fragment_size: 200 },
                    content: { fragment_size: 200 }
                  }
                }

    dsl = {
        query: {
          bool: {
            should: shoulds
          }
        }
    }

    if options[:from].present? && options[:to].present?
      filter = {
                range: {
                    created_at: {
                      gte: options[:from],
                      lte: options[:to]
                    }
                }
              }

      dsl[:filter] = filter

      dsl = { query: {
                       filtered: dsl
                     }
            }
    end

    dsl[:highlight] = highlight
    facets = {
      alert_id_counts: {
        terms: {
          field: :alert_id,
          size:50,
          all_terms: false
        }
      }
    }

    dsl[:facets] = facets
    dsl[:fields] = [:id, :alert_id, :title, :url, :keywords, :created_at]
    dsl
  end

  def self.search(options={})
    criteria = build_criterias(options)
    # __elasticsearch__.search(criteria)
    # use raw version since elasticsearch-model does not support facet query
    results = FeedEntry.__elasticsearch__.client.search(index: FeedEntry.index_name, body: criteria)
    FeedEntrySearchResultPresenter.new(results)
  end

  def has_content?
    self.content.present?
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
    feed_entry = FeedEntry.where(options.slice(:title, :url, :alert_id)).first
    FeedEntry.create!(options) unless feed_entry
  end

  def process_url
    ProcessFeedEntryUrlJob.set(wait: 10.seconds).perform_later(self.id)
  end

end
