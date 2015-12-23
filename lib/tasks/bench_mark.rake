require 'benchmark'
# require 'ruby-prof'

namespace :feed do
  
  desc 'Benchmark for one alert'
  task benchmark: :environment do
    option = {
      url: "http://feeds.reuters.com/reuters/globalmarketsNews",
      name: "Reuter"
    }
    keywords = [ "bussines", "technology", "social", "art", "culture", "gloabl", "news", "deal", "attempt", "sweet"]
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
end