class ProcessFeedJob < ActiveJob::Base
  queue_as :process_feed

  def perform(alert_id)
    alert = Alert.find(alert_id)
    if alert
      ProcessFeed.start(alert)
    else
      Rails.logger.debug { "could not find any alert with id: #{alert_id}" }
    end
  end
end
