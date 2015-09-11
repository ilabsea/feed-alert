class AddSmsAlertTemplateToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :sms_alert_template, :text
  end
end
