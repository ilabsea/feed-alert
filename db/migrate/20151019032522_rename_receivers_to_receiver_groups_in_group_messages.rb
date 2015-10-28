class RenameReceiversToReceiverGroupsInGroupMessages < ActiveRecord::Migration
  def change
  	rename_column :group_messages, :receivers, :receiver_groups
  end
end
