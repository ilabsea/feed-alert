# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Project < ActiveRecord::Base
  belongs_to :user

  has_many :project_permissions, dependent: :destroy
  has_many :shared_users, class_name: 'User', through: :project_permissions

  has_many :group_permissions, dependent: :destroy

  validates :name, presence: true

  has_many :alerts

  def access_role=(role)
    @access_role = role
    self
  end

  def admin_access_role?
    @access_role != User::PERMISSION_ROLE_NORMAL
  end
end
