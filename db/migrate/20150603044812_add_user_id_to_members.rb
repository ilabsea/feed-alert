class AddUserIdToMembers < ActiveRecord::Migration
  def change
    add_reference :members, :user, index: true
    add_foreign_key :members, :users
  end
end
