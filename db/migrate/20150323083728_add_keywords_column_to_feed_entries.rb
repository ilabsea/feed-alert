class AddKeywordsColumnToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :keywords, :text, array: true
  end
end
