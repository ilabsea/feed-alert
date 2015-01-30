class CreateAlertPlaces < ActiveRecord::Migration
  def change
    create_table :alert_places do |t|
      t.references :alert, index: true
      t.references :place, index: true

      t.timestamps null: false
    end
    add_foreign_key :alert_places, :alerts
    add_foreign_key :alert_places, :places
  end
end
