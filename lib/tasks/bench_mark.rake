require 'benchmark'

namespace :feed do
  
  desc 'Recreate Index and Mapping for search structure'
  task benchmark: :environment do
    option = {
      url: "http://feeds.reuters.com/reuters/globalmarketsNews",
      name: "Reuter"
    }
    keywords = [ "bussines", "technology", "social", "art", "culture", "gloabl", "news"]
    alert = Alert.where(option).first_or_create
    
    keywords.each do |item|
      keyword = Keyword.where(name: item).first_or_create
      alert_keyword = alert.alert_keywords.build(keyword: keyword)
      alert_keyword.save
    end

    time = Benchmark.realtime do |x|
      ProcessFeed.start(alert)  
    end
    p time
  end
end