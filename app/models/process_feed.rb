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

        feed_jira.entries.each do |reader_entry|
          entry_attrs = {
            title: reader_entry.title,
            url: reader_entry.url,
            published_at: reader_entry.published,
            summary: reader_entry.summary,
            alert_id: alert.id,
            feed_id: feed.id
          }
          FeedEntry.process_with(entry_attrs)
        end
      else
        Rails.logger.debug { "alert: #{alert.name} with url: #{alert.url} could not be read with error: #{feed_jira.class}" }
      end
    rescue Feedjira::FetchFailure => e
      self.mark_error(alert, e.message)
    rescue Feedjira::NoParserAvailable => e
      self.mark_error(alert, e.message)
    end

  end

  def self.mark_error(alert, error_message)
    alert.invalid_url = true
    alert.error_message = error_message
    alert.save
  end



end