class AddSmsAlertToGroupMessages < ActiveRecord::Migration
  def change
    add_column :group_messages, :sms_alert, :boolean, :default => false
  end
end
