class RenameProjectChannelsToChannelAccesses < ActiveRecord::Migration
  def change
  	rename_table :project_channels, :channel_accesses
  end
end
