class ChangeUrlDataTypeInFeedEntries < ActiveRecord::Migration
  def up
    change_column :feed_entries, :url, :text, length: 500
  end

  def down
    change_column :feed_entries, :url, :text
  end
end
