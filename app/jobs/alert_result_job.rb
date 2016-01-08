class AlertResultJob < ActiveJob::Base
  queue_as :alert_result

  def perform(alert_id)
    alert = Alert.find(alert_id)
    if alert
      AlertResult.new([alert]).run
    else
      Rails.logger.debug { "could not find any alert with id: #{alert.id}" }
    end
  end

end