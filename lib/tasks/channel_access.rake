namespace :alert do
  desc "move the channel from alerts to projects through channel_accesses"
  task :migrate_channel => :environment do
    Alert.migrate_channel
  end
end