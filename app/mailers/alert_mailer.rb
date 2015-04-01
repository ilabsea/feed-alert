class AlertMailer < ApplicationMailer
  def notify_matched(alert, group, date_range)

    @alert = alert
    @group = group
    @date_range = date_range

    emails_to = []
    group.members.each do |member|
      emails_to << member.email if member.email_alert
    end

    mail(to: emails_to, subject: "Keywords matched your #{@alert.name}")
  end
end
