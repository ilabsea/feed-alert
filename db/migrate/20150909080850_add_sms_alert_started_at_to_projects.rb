class AddSmsAlertStartedAtToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :sms_alert_started_at, :datetime
  end
end
