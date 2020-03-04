class CreateAlertKeywordSet < ActiveRecord::Migration
  def change
    create_table :alert_keyword_sets do |t|
      t.references :alert, index: true
      t.references :keyword_set, index: true

      t.timestamps null: false
    end

    add_foreign_key :alert_keyword_sets, :alerts
    add_foreign_key :alert_keyword_sets, :keyword_sets
  end
end
