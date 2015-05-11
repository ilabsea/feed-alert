class AddFromTimeToTimeToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :from_time, :string
    add_column :alerts, :to_time, :string
  end
end
