class AddErrorMessageErrorToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :invalid_url, :boolean, default: false
    add_column :alerts, :error_message, :string
  end
end
