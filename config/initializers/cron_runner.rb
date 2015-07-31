queue_name = 'cron'

schedules = {
  'Read feeds from alert' => {
    'class' => 'FeedReaderFromAlertCron',
    'cron'  => '*/10 * * * *',
    'queue' => 'cron'
  },

  'Alert fetched feed if criteria match' => {
    'class' => 'AlertResultCron',
    'cron'  => '*/25 * * * *',
    'queue' => 'default'
  },

  'Remove old feed entries for a month' => {
    'class' => 'FeedEntryCleanUpCron',
    'cron'  => '0 0 * * *',
    'queue' => 'default'
  }
}

Sidekiq::Cron::Job.load_from_hash schedules