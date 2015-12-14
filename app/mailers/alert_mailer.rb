class AlertMailer < ApplicationMailer
  def notify_matched(search_highlight, alert_id, group_name, emails_to, date_range)

    @alert = Alert.find(alert_id)
    @group_name = group_name
    @date_range = date_range
    @search_highlight = search_highlight


    roadie_mail(to: emails_to, subject: "Keywords matched your #{@alert.name}")
  end

  def notify_group_message(group_message, emails_to)
  	@group_message = group_message
  	roadie_mail(to: emails_to, subject: "Group Message")
  end
end
