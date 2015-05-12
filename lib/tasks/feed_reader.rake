namespace :feed do
  
  desc 'Recreate Index and Mapping for search structure'
  task recreate_index: :environment do
    FeedEntry.recreate_index!
  end

  desc 'Read Feed From Alert source'
  task read_data: :environment do
    FeedReader.from_alert
  end

  desc 'Alert Match feed entries'
  task alert: :environment do

    from = Time.zone.now - ENV['PROCESS_TIME_IN_MINUTES'].to_i.minutes
    to   = Time.zone.now
    date_range = DateRange.new(from, to)

    Alert.apply_search(date_range)
  end

end