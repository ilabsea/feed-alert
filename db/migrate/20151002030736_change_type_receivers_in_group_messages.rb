class ChangeTypeReceiversInGroupMessages < ActiveRecord::Migration
  def change
  	change_column :group_messages, :receivers, :text
  end
end
