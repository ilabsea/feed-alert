class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :project_permissions
  has_many :channel_permissions
end
