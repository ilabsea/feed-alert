class AddUniqueConstraintToFeedEntries < ActiveRecord::Migration
  def up
    # change_column :feed_entries, :fingerprint, :string, limit: 32
    # add_index :feed_entries, :fingerprint, unique: true
  end

  def down
    remove_index :feed_entries, :fingerprint
    change_column :feed_entries, :fingerprint, :string
  end
end
