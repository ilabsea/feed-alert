class AlertMailer < ApplicationMailer
  def notify_matched(alert, from, to)
    @alert = alert
    @date_range = DateRange.new(Time.zone.now-10.days, Time.zone.now)
    
    email  = 'channa.info@gmail.com'
    mail(to: email, subject: "Keywords matched your #{alert.name}")
  end
end
