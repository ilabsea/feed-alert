class CreateKeywordSet < ActiveRecord::Migration
  def change
    create_table :keyword_sets do |t|
      t.string :name, null: false
      t.text :keyword, null: false
      t.references :user, null: false

      t.timestamps null: false
    end
  end
end
