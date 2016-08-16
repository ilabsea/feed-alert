class AddAlertTypeToGroupMessages < ActiveRecord::Migration
  def change
    add_column :group_messages, :alert_type, :string, array: true, default: []
  end
end
