class AddMatchedToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :matched, :boolean, default: false
  end
end
