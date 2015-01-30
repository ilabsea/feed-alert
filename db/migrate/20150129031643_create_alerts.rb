class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :name
      t.string :url
      t.float :interval
      t.string :interval_unit
      t.text :email_template
      t.text :sms_template

      t.timestamps null: false
    end
  end
end
