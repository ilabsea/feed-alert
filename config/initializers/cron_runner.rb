schedules = {
  'Read feeds from alert' => {
    'class' => 'FeedReaderFromAlertCron',
    'cron'  => '*/20 * * * *',
    'queue' => 'cron'
  },

  'Alert fetched feed if criteria match' => {
    'class' => 'AlertResultCron',
    'cron'  => '*/30 * * * *',
    'queue' => 'default'
  },

  'Remove old feed entries for a month' => {
    'class' => 'FeedEntryCleanUpCron',
    'cron'  => '0 0 1 * *',
    'queue' => 'default'
  }
}

Sidekiq::Cron::Job.load_from_hash schedules