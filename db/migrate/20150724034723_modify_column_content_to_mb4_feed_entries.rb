class ModifyColumnContentToMb4FeedEntries < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE feed_entries 
            CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
            MODIFY content longtext
            CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
    SQL
  end
end
