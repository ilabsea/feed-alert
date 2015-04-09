class AddColumnFeedEntriesCountToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :feed_entries_count, :integer, default: 0, length: 11
  end
end
