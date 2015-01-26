class AddUserNameRoleEmailAlertSmsAlert < ActiveRecord::Migration
  def change
    add_column :users, :user_name, :string
    add_column :users, :role, :string
    add_column :users, :email_alert, :boolean, default: false
    add_column :users, :sms_alert, :boolean, default: false
    add_column :users, :full_name, :string

    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
