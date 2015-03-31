class AlertMailer < ApplicationMailer
  def notify_matched(alert, group, emails_to, date_range)

    @alert = alert
    @group = group
    @date_range = date_range

    mail(to: emails_to, subject: "Keywords matched your #{@alert.name}")
  end
end
