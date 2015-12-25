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
require 'elasticsearch/persistence/model'

class Entry
  include Elasticsearch::Persistence::Model
  # index_name "feed_entry-#{Rails.env}"
  # document_type "entry"

  attribute :alert_id, Integer
  attribute :title, String, mapping: { analyzer: 'english' }
  attribute :url, String, mapping: { analyzer: 'english' }
  attribute :summary, String, mapping: { analyzer: 'english' }
  attribute :alerted, Boolean, default: false, mapping: { analyzer: 'english' }
  attribute :fingerprint, String, mapping: { analyzer: 'english' }
  attribute :feed_id, Integer
  attribute :keywords

  attribute :content, nil, mapping: { type: 'attachment', fields: { 
                                                        author: { index: "no"},
                                                        date: { index: "no"},
                                                        content: { store: "yes",
                                                                   type: "string",
                                                                   term_vector: "with_positions_offsets"
                                                                }
                                                      }

                                }


  


 


  def to_hash(options={})
    hash = self.as_json
    hash["content"] = {
      "_detect_language": false,
      "_language": "en",
      "_indexed_chars": -1 ,
      "_content_type": "text/html",
      "_content": Base64.encode64(self.content)
    }
    hash
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

end
