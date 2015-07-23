class ChangeColumnUrlFeedEntries < ActiveRecord::Migration
  def change
    change_column :feed_entries, :url, :text
  end
end
