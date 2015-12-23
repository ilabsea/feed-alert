class RemoveMacthedFromFeedEntries < ActiveRecord::Migration
  def change
    remove_column :feed_entries, :matched
  end
end
