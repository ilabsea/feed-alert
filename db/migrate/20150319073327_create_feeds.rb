class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :title
      t.text :description

      t.references :alert, index: true
      t.timestamps null: false
    end

    add_foreign_key :feeds, :alerts
  end
end