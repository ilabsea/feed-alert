class AlertMailer < ApplicationMailer
  def notify_matched(email, snapshots)
    @snapshots = snapshots
    roadie_mail(to: email, subject: "Hourly Digest - Keywords Matched")
  end

  def notify_group_message(group_message, emails_to)
    @group_message = group_message
    roadie_mail(to: emails_to, subject: "Group Message")
  end
end
