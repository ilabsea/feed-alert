class CreateGroupPermissions < ActiveRecord::Migration
  def change
    create_table :group_permissions do |t|
      t.references :user, index: true
      t.references :group, index: true
      t.references :alert, index: true
      t.references :project, index: true
      t.string :role
      t.integer :order_number, default: 0

      t.timestamps null: false
    end
    add_foreign_key :group_permissions, :users
    add_foreign_key :group_permissions, :groups
    add_foreign_key :group_permissions, :alerts
    add_foreign_key :group_permissions, :projects
  end
end
