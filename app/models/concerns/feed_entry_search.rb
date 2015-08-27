module FeedEntrySearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name    "feed_entry-#{Rails.env}"
    document_type "feed_entry"

    settings index: { number_of_shards: 5 } do
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

  end


  def sync_index(action_type)
    p "Try to sync index with action_type: #{action_type}"
    Rails.logger.debug { "Try to sync index with action_type: #{action_type}" }
    if action_type =='delete'
      IndexerJob.set(wait: 1.second).perform_later(action_type, self.class.to_s, self.id)
    elsif self.content.present?
      Rails.logger.debug { "Index sync for #{self.id}" }
      IndexerJob.set(wait: 1.second).perform_later(action_type, self.class.to_s, self.id)
    else
      Rails.logger.debug { "Index not sync for #{self.id}" }
    end
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

    def alert_criterias alert_options
      keywords = alert_options[:keywords]
      alert_id = alert_options[:id]
      criterias = []
      keywords.each do |keyword|
        match_phrase = {
                        query: {
                            multi_match: {
                              query: keyword,
                              type: "phrase",
                              fields: ['title', 'summary', 'content']
                            }
                        },
                        filter: {
                          term: {
                            alert_id: alert_id
                          }
                        }
                     }

        criterias << { filtered: match_phrase}
      end
      criterias
    end

    def build_criterias options
      shoulds = []

      options[:q].each do |alert_options|
        shoulds += alert_criterias(alert_options) unless alert_options[:keywords].blank?
      end

      dsl = {
          query: {
            bool: {
              should: shoulds
            }
          }
      }

      if options[:from].present? && options[:to].present?
        dsl[:filter] = {
                  range: {
                      created_at: {
                        gte: options[:from],
                        lte: options[:to]
                      }
                  }
                }

        dsl = { query: {
                         filtered: dsl
                       }
              }
      end

      highlight_options = { 
                            fragment_size: 180, 
                            number_of_fragments: 2,
                            # type: :experimental
                            # fragmenter: :sentence 
                          }

      highlight = { 
        pre_tags: ["<em class='highlight'>"],
        post_tags: ["</em>"],
        fields: {
          title: highlight_options,
          summary: highlight_options,
          content: highlight_options
        }
      }

      facets = {
        alert_id_counts: {
          terms: {
            field: :alert_id,
            size:50,
            all_terms: false
          }
        }
      }

      fields = [:id, :alert_id, :title, :url, :keywords, :created_at]
      dsl[:highlight] = highlight
      dsl[:facets] = facets
      dsl[:_source] = {include: fields}
      dsl[:size] = 50
      dsl
    end

    def search(options={})
      criteria = build_criterias(options)
      # __elasticsearch__.search(criteria)
      # use raw version since elasticsearch-model does not support facet query
      Rails.logger.info "Elasticsearch query: #{criteria}"
      results = self.__elasticsearch__.client.search(index: self.index_name, body: criteria)
      FeedEntrySearchResultPresenter.new(results)
    end
  end

end