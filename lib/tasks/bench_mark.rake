require 'benchmark'
# require 'ruby-prof'

namespace :feed do
  
  desc 'Benchmark for one alert'
  task benchmark: :environment do
    option = {
      url: "http://feeds.reuters.com/reuters/globalmarketsNews",
      name: "Reuter"
    }
    keywords = [ 
"Business",
"Markets",
"World",
"Politics",
"Technology",
"Opinion",
"Money",
"Pictures",
"Videos"]
    alert = Alert.where(option).first_or_create
    
    keywords.each do |item|
      keyword = Keyword.where(name: item).first_or_create
      AlertKeyword.where(alert_id: alert.id, keyword_id: keyword.id).first_or_create
    end
    # RubyProf.start
    time = Benchmark.realtime do |x|
      1.times.each do
        ProcessFeed.start(alert)
      end 
    end
    p "Benchmark for one alert : #{time}"
  end


 

  desc "Benchmark all alert"
  task benchmark_all: :environment do
    time = Benchmark.realtime do |x|
      FeedReader.from_alert
    end
    p "Benchmark for all alert : #{time}"
  end

  desc "Benchmark all alert"
  task entry: :environment do
    alert = Alert.find(15)
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
          feed_id: feed.id,
          alerted: false
        }

        entry_attrs[:content] = FetchPage.instance.run(entry_attrs[:url])
        entry_attrs[:keywords] = alert.keywords.map(&:name)
        Entry.create(entry_attrs)
      end
    end
  end
end