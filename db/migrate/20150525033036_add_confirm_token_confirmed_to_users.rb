class AddConfirmTokenConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmed_token, :string
    add_column :users, :confirmed_at, :datetime
    remove_column :users, :user_name, :string
  end
end
