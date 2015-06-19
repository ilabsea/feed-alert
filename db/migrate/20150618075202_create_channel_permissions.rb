class CreateChannelPermissions < ActiveRecord::Migration
  def change
    create_table :channel_permissions do |t|
      t.references :channel, index: true
      t.references :user, index: true
      t.string :role

      t.timestamps null: false
    end
    add_foreign_key :channel_permissions, :channels
    add_foreign_key :channel_permissions, :users
  end
end
