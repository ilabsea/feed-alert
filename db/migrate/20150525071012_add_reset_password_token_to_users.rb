class AddResetPasswordTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_at, :datetime
  end
end
