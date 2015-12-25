module SearchQuery
  extend ActiveSupport::Concern

  def map_attachment(hash)
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
                              fields: ['content']
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

      
      dsl[:filter] = {
                term: {
                  alerted: options[:alerted]
                }
              }

      dsl = { query: {
                       filtered: dsl
                     }
            }

      highlight_options = { 
                            fragment_size: 180, 
                            number_of_fragments: 2,
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

    def result(options={})
      criteria = build_criterias(options)
      # __elasticsearch__.search(criteria)
      # use raw version since elasticsearch-model does not support facet query
      results = self.__elasticsearch__.client.search(index: self.index_name, body: criteria)
      FeedEntrySearchResultPresenter.new(results)
    end
  end

end