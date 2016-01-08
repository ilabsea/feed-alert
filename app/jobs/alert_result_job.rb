class AlertResultJob < ActiveJob::Base
  queue_as :alert_result

  def perform(alert_id)
    alert = Alert.find(alert_id)
    AlertResult.new([alert]).run
  end

end