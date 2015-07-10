class ApplicationMailer < ActionMailer::Base
  default from: ENV['NO_REPLY_MAIL']
  layout 'mailer'
  self.asset_host = nil
  include Roadie::Rails::Mailer

  add_template_helper(MailerHelper)
end
