class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :project_permissions
end
