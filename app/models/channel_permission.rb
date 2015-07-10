# == Schema Information
#
# Table name: channel_permissions
#
#  id         :integer          not null, primary key
#  channel_id :integer
#  user_id    :integer
#  role       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChannelPermission < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user

  def admin_role?
    self.role == User::PERMISSION_ROLE_ADMIN
  end
end
