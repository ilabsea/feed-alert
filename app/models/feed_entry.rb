# == Schema Information
#
# Table name: feed_entries
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  url          :string(255)
#  summary      :text(65535)
#  content      :text(4294967295)
#  alerted      :boolean          default(FALSE)
#  alert_id     :integer
#  feed_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  keywords     :text(65535)
#
require 'elasticsearch/persistence/model'

class FeedEntry
  include Elasticsearch::Persistence::Model
  include SearchQuery

  ELASTIC_INDEX_NAME = "feed_entries"
  ELASTIC_TYPE_NAME = "feed_entry"

  attribute :alert_id, Integer
  attribute :title, String, mapping: { analyzer: 'english' }
  attribute :url, String, mapping: { analyzer: 'english' }
  attribute :summary, String, mapping: { analyzer: 'english' }
  attribute :alerted, Boolean, default: false, mapping: { analyzer: 'english' }
  attribute :feed_id, Integer
  attribute :keywords #denormalize keywords from alerts

  attribute :content, nil, mapping: { type: 'attachment', fields: { 
                                                        author: { index: "no"},
                                                        date: { index: "no"},
                                                        content: { store: "yes",
                                                                   type: "string",
                                                                   term_vector: "with_positions_offsets"
                                                                }
                                                      }
                                }

  def self.recreate_index!
    mappings = {}
    mappings[FeedEntry::ELASTIC_TYPE_NAME]= {

                    "properties": {
                      "alerted": {
                        "type": "boolean"
                      },
                      "alert_id": {
                        "type": "integer"
                      },
                      "title": {
                        "analyzer": "english",
                        "type": "string"
                      },
                      "title_not_analyzed": {
                        #for exact match
                        "index": "not_analyzed",
                        "type": "string"
                      },

                      "url": {
                        "analyzer": "english",
                        "type": "string"
                      },
                      "summary": {
                        "analyzer": "english",
                        "index_options": "offsets",
                        "type": "string"
                      },
                      "content": {
                        "type": "attachment",
                        "fields": {
                          "author": {
                            "index": "no"
                          },
                          "date": {
                            "index": "no"
                          },
                          "content": {
                            "store": "yes",
                            "type": "string",
                            "term_vector": "with_positions_offsets"
                          }
                        }
                      }
                    }
              }
    options = {
      index: FeedEntry::ELASTIC_INDEX_NAME,
    }
    self.gateway.client.indices.delete(options) rescue nil
    self.gateway.client.indices.create(options.merge( body: { mappings: mappings}))   
  end

  def self.result(options={})
    criteria = build_criterias(options)
    # use raw version since elasticsearch-model does not support facet query
    results = self.gateway.client.search(index: self.index_name, body: criteria)
    FeedEntrySearchResultPresenter.new(results)
  end  


  def to_hash(options={})
    hash = self.as_json
    map_attachment(hash) if !self.alerted
    hash[:title_not_analyzed] = hash[:title]
    hash
  end

  def self.mark_as_alerted(ids)
    #trigger feed_entry update with elastic
    feed_entries = FeedEntry.find(ids)
    feed_entries.each do |feed_entry|
      feed_entry.alerted = true
      feed_entry.save
    end
  end

  def self.query_builder(options={})
    bool_filter = {must: [] }
    terms = []
    options.each do |key,value|
      term = {term: {}}
      term[:term][key] = value
      terms << term
    end

    bool_filter[:must] = terms

    filter = {
      bool: bool_filter
    }

    criterias = {
      query: {
        filtered: {
          query: {
            match_all: {

            }
          },
          filter: filter 
        },
        
      },
      size: 500
    }

  end

  def self.where(options={})
    self.search(self.query_builder(options))
  end

  def self.remove(options={})
    query = self.query_builder(options)
    self.bulk_remove(query)
  end

  def self.bulk_remove(query)
    feed_entries = self.search(query)
    feed_entries.each do |feed_entry|
      feed_entry.destroy
    end
  end

  def self.remove_unmatched_for(date_time)
    must = []
    must << { range: {updated_at: {lte: "#{date_time}"}} }
    must << { term: {alerted: false} }

    query = {
      query: {
        filtered: {
          query: {
            match_all: {

            }
          },
          filter: {
            bool: {
              must: must
            }
          } 
        },
        
      },
      size: 500
    }

    result = self.bulk_remove(query)
  end

end
