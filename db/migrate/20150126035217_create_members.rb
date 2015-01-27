class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :full_name
      t.string :email
      t.string :phone
      t.boolean :email_alert
      t.boolean :sms_alert

      t.timestamps null: false
    end
  end
end
