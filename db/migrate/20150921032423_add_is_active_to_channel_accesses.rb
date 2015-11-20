class AddIsActiveToChannelAccesses < ActiveRecord::Migration
  def change
  	add_column :channel_accesses, :is_active, :boolean, default: false
  end
end
