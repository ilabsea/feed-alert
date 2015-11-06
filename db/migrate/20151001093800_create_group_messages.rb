class CreateGroupMessages < ActiveRecord::Migration
  def change
    create_table :group_messages do |t|
      t.string :receivers
      t.text :message
      t.references :user
      t.timestamps null: false
    end
    add_foreign_key :group_messages, :users
  end
end
