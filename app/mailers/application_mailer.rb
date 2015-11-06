class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['APP_NAME']} <#{ENV['NO_REPLY_EMAIL']}>"
  layout 'mailer'
  self.asset_host = nil
  include Roadie::Rails::Mailer

  add_template_helper(MailerHelper)
end
