class SmsAlertJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    Sms.instance().send(options)
  end
end
