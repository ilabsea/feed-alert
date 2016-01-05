class ProcessFeed
  def self.start(alert)
    begin
      feed_jira = Feedjira::Feed.fetch_and_parse(alert.url)
      if feed_jira.class.to_s.include?("Feedjira::Parser::")

        feed_attrs = {
           title: feed_jira.title,
           description: feed_jira.description,
           url: feed_jira.feed_url,
           alert_id: alert.id
        }

        feed = Feed.process_with(feed_attrs)

        feed_jira.entries.each_with_index do |reader_entry, i|
          entry_attrs = {
            title: reader_entry.title,
            url: reader_entry.url,
            published_at: reader_entry.published,
            summary: reader_entry.summary,
            alert_id: alert.id,
            feed_id: feed.id
          }

          feed_entry = FeedEntry.where(title_not_analyzed: entry_attrs[:title], alert_id: alert.id).first
          if feed_entry 
            if feed_entry.url != entry_attrs[:url]
              entry_attrs[:content] = FetchPage.instance.run(entry_attrs[:url])
              entry_attrs[:keywords] = alert.keywords.map(&:name)
              feed_entry.update_attributes(entry_attrs)
            end
          else
            entry_attrs[:content] = FetchPage.instance.run(entry_attrs[:url])
            entry_attrs[:keywords] = alert.keywords.map(&:name)            
            feed_entry = FeedEntry.create(entry_attrs)
          end
          p "*****finish fetching url: #{feed_entry.url}****"

          sleep(ENV['SLEEP_BETWEEN_REQUEST_IN_SECOND'].to_i) if i < feed_jira.entries.length - 1
        end
      else
        Rails.logger.debug { "alert: #{alert.name} with url: #{alert.url} could not be read with error: #{feed_jira.class}" }
      end
    rescue Feedjira::FetchFailure => e
      alert.mark_error("Fetching feed with failure")
    rescue Feedjira::NoParserAvailable => e
      alert.mark_error("Invalid feed format.")
    rescue NoMethodError => e
      alert.mark_error("Invalid feed url")
    rescue Exception => e
      alert.mark_error("Unexpected error")
    end

  end


end