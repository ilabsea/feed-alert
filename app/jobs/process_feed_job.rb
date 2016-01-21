class ProcessFeedJob < ActiveJob::Base
  queue_as :process_feed

  after_perform do |job|
    alert_id = job.arguments.first
    alert = Alert.find(alert_id)
    AlertResultJob.set(wait: 10.minutes).perform_later(alert_id)
    ProcessFeedJob.set(wait: 20.minutes).perform_later(alert_id) if alert.valid
  end

  def perform(alert_id)
    alert = Alert.find(alert_id)
    if alert
      ProcessFeed.start(alert)
    else
      Rails.logger.debug { "could not find any alert with id: #{alert.id}" }
    end
  end

  def self.is_job_running?(alert_id)
    queue = ::Sidekiq::Queue.new("process_feed")
    queue.each do |job|
      queue_alert_id = job.args.first["arguments"][0]
      if queue_alert_id == alert_id
        return true
      end
    end
    return false
  end

end