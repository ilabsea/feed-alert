class ChangeSmsAlertEndedAtInProjects < ActiveRecord::Migration
  def change
  	change_column :projects, :sms_alert_ended_at,  :string
  end
end
