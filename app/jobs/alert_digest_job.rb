class AlertDigestJob < ActiveJob::Base
  queue_as :alert_result

  def perform(receiver)
    return if receiver.nil?

    receiver.each do |email, alert_ids|
      AlertDigest.new(email, alert_ids).run
    end
  end
end
