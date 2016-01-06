namespace :feed do
  
  desc 'Recreate Index and Mapping for search structure'
  task recreate_index: :environment do
    FeedEntry.recreate_index!
  end

  desc 'Read Feed From Alert source'
  task alert: :environment do
    FeedReader.from_alert
  end

  desc 'Alert Match feed entries'
  task apply_search: :environment do
    ApplySearch.run
  end

  desc 'Remove old feed entries from database'
  task clean_feed_entry: :environment do
    FeedEntry.where(['updated_at < ?', 1.month.ago]).destroy_all
  end

  desc 'Migrate Old data'
  task upgrade_data: :environment do
    user_email = 'admin@ilabsea.org' # soksamnangcdc@online.com.kh
    user = User.find_by(email: user_email)

    MigrationUser.start(user)
  end

  desc 'Remove unmatched feed'
  task remove_unmatched: :environment do
    FeedEntry.remove_unmatched_for(2.days.ago)
  end

end