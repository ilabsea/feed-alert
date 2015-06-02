class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :user

  has_many :project_permissions, dependent: :destroy
  has_many :shared_users, class_name: 'User', through: :project_permissions

  validates :name, presence: true

  has_many :alerts


  def self.shared_users
    user_sql = ProjectPermission.select('user_id').where(project_id: ids).uniq
    User.includes(:project_permissions).where(id: user_sql).uniq
  end

  def access_role=(role)
    @access_role = role
    self
  end

  def admin_access_role?
    @access_role != User::PERMISSION_ROLE_NORMAL
  end
end
