class CreateAlertKeywords < ActiveRecord::Migration
  def change
    create_table :alert_keywords do |t|
      t.references :alert, index: true
      t.references :keyword, index: true

      t.timestamps null: false
    end
    add_foreign_key :alert_keywords, :alerts
    add_foreign_key :alert_keywords, :keywords
  end
end
