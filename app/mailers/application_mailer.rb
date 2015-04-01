class ApplicationMailer < ActionMailer::Base
  default from: ENV['FEED_ALERT_MAIL']
  layout 'mailer'
  self.asset_host = nil
  include Roadie::Rails::Mailer
end
