class AddErrorMessageErrorToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :invalid_url, :integer, default: 0
    add_column :alerts, :error_message, :string
  end
end
