class AlertDigestJob < ActiveJob::Base
  queue_as :alert_result

  def perform(email, alert_ids)
    return if email.nil? || alert_ids.empty?

    AlertDigest.new(email, alert_ids).run
  end
end
