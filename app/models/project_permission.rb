class ProjectPermission < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  def admin_role?
    self.role == User::PERMISSION_ROLE_ADMIN
  end


end