class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :member, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
    add_index :memberships, [:member_id, :group_id], unique: true
  end
end
