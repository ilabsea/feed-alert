namespace :group_message do
  desc "move email_alert and sms_alert to alert_type"
  task :migrate_alert_type => :environment do
    GroupMessage.migrate_alert_type
  end
end
