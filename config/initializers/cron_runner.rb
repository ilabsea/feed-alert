schedules = {
  'Read feeds from alert' => {
    'class' => 'FeedReaderFromAlertCron',
    'cron'  => '0 */1 * * *',
    'queue' => 'cron'
  },

  'Remove old feed entries for a month' => {
    'class' => 'FeedEntryCleanUpCron',
    'cron'  => '0 0 */2 * *',
    'queue' => 'default'
  }
}

Sidekiq::Cron::Job.load_from_hash schedules