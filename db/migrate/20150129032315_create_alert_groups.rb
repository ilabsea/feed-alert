class CreateAlertGroups < ActiveRecord::Migration
  def change
    create_table :alert_groups do |t|
      t.references :alert, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
    add_foreign_key :alert_groups, :alerts
    add_foreign_key :alert_groups, :groups
  end
end
