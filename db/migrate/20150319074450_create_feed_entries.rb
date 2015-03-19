class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.string :url
      t.datetime :published_at
      t.text :summary
      t.text :content, limit: 4294967295
      t.boolean :alerted, default: false
      t.string :fingerprint
      t.references :alert, index: true
      t.references :feed, index: true

      t.timestamps null: false
    end
    add_foreign_key :feed_entries, :alerts
    add_foreign_key :feed_entries, :feeds
  end
end
