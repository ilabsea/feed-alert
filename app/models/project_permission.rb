# == Schema Information
#
# Table name: project_permissions
#
#  id         :integer          not null, primary key
#  role       :string(255)
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectPermission < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  def admin_role?
    self.role == User::PERMISSION_ROLE_ADMIN
  end


end
