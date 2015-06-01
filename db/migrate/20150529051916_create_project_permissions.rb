class CreateProjectPermissions < ActiveRecord::Migration
  def change
    create_table :project_permissions do |t|
      t.string :role
      t.references :project, index: true
      t.references :user, index: true

      t.timestamps null: false
    end

    add_foreign_key :project_permissions, :users
    add_foreign_key :project_permissions, :projects

  end
end
