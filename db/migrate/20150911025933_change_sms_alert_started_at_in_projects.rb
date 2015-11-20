class ChangeSmsAlertStartedAtInProjects < ActiveRecord::Migration
  def change
  	change_column :projects, :sms_alert_started_at,  :string
  end
end
