class AddEmailAlertToGroupMessages < ActiveRecord::Migration
  def change
    add_column :group_messages, :email_alert, :boolean, :default => false
  end
end
