class AddEmailAlertedToFeedEntry < ActiveRecord::Migration
  def up
    property = {
      feed_entry: {
        properties: {
            email_alerted: {type: "boolean" }
        }
      }
    }
    elasticsearch_url = "#{ENV['ELASTICSEARCH_URL']}/feed_entries/_mapping/feed_entry"
    Kernel.system "curl -XPUT '#{elasticsearch_url}' -d '#{property.to_json}'"
  end
end
