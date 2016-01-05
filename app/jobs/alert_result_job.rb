class AlertResultJob < ActiveJob::Base
  queue_as :alert_result

  def perform(alert)
    AlertResult.new([alert]).run
  end

end