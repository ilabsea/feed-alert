class ChannelPermission < ActiveRecord::Base
  belongs_to :channel
  belongs_to :user

  def admin_role?
    self.role == User::PERMISSION_ROLE_ADMIN
  end
end
