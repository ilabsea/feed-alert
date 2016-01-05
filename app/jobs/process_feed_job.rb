class ProcessFeedJob < ActiveJob::Base
  queue_as :process_feed

  after_perform do |job|
    alert_id = job.arguments.first
    alert = Alert.find(alert_id)
    AlertResultJob.set(wait: 10.minutes).perform_later(alert)
    ProcessFeedJob.set(wait: 20.minutes).perform_later(alert)
  end

  def perform(alert)
    if alert
      ProcessFeed.start(alert)
    else
      Rails.logger.debug { "could not find any alert with id: #{alert.id}" }
    end
  end
end
