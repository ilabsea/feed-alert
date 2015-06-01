class ProjectPermissionSerializer < ActiveModel::Serializer
  attributes :user_id, :project_id, :role
end
