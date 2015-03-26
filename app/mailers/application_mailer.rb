class ApplicationMailer < ActionMailer::Base
  default from: ENV['FEED_ALERT_MAIL']
  layout 'mailer'
end
