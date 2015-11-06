class AddSmsAlertEndedAtToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :sms_alert_ended_at, :datetime
  end
end
