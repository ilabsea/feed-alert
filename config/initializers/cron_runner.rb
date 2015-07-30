queue_name = 'low_priority'

schedules = {
  'Read feeds from alert' => {
    'class' => 'FeedReaderFromAlertCron',
    'cron'  => '0,5,10,15,20,25,30,35,40,45,50,55 * * * *',
    'queue' => queue_name
  },

  'Alert fetched feed if criteria match' => {
    'class' => 'AlertResultCron',
    'cron'  => '*/30 * * * *',
    'queue' => queue_name
  },

  'Remove old feed entries for a month' => {
    'class' => 'FeedEntryCleanUpCron',
    'cron'  => '0 0 * * *',
    'queue' => queue_name
  }
}

Sidekiq::Cron::Job.load_from_hash schedules