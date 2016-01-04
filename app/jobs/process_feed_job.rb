class ProcessFeedJob < ActiveJob::Base
  queue_as :process_feed

  after_perform do |job|
    p "&&&&&&&&&&&&&&&&&&after_perform&&&&&&&&&&&&&&&&"
    p ActiveJob
    alert_id = job.arguments.first
    alert = Alert.find(alert_id)
    AlertResult.new([alert]).run
    p "&&&&&&&&&&&&&&&&&&&&&&&&&&&"
  end

  def perform(alert_id)
    p 'performing'
    alert = Alert.find(alert_id)
    if alert
      ProcessFeed.start(alert)
    else
      Rails.logger.debug { "could not find any alert with id: #{alert_id}" }
    end
  end
end
