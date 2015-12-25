module FeedEntrySearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name    "feed_entry-#{Rails.env}"
    document_type "feed_entry"

    settings index: { number_of_shards: 5 } do
      mappings do
        indexes :alerted
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

  end


  def sync_index(action_type)
    if action_type =='delete'
      IndexerJob.set(wait: 3.second).perform_later(action_type, self.class.to_s, self.id, self.alert_id)
    elsif self.content.present?
      IndexerJob.set(wait: 3.second).perform_later(action_type, self.class.to_s, self.id, self.alert_id)
    end
  end

  def as_indexed_json(options={})
      hash = self.as_json
      map_attachment(hash)
      # hash["content"] = {
      #   "_detect_language": false,
      #   "_language": "en",
      #   "_indexed_chars": -1 ,
      #   # "_content_type": "text/html",
      #   "_content": Base64.encode64(self.content)
      # }
      # hash
  end

  module ClassMethods
    # Util for creating index
    def create_index
      options = {
        index: self.index_name,
        body: { settings: self.settings.to_hash,
                mappings: self.mappings.to_hash
              }
      }
      self.__elasticsearch__.client.indices.create(options)
    end

    def recreate_index!
      self.__elasticsearch__.create_index! force: true
      self.__elasticsearch__.refresh_index!
    end

  end

end