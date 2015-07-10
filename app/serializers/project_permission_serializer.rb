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

class ProjectPermissionSerializer < ActiveModel::Serializer
  attributes :user_id, :project_id, :role
end
