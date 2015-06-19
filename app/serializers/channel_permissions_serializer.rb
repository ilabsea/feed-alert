class ChannelPermissionsSerializer < ActiveModel::Serializer
  attributes :user_id, :channel_id, :role

end