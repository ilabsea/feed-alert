module Channels::Accessible
  class UserChannelAccessible < ChannelAccessible
    def list
      admin_project_ids = object.project_with_admin_permission.pluck(:id)
      project_channels = ChannelAccess.where(project_id: admin_project_ids)
      channel_ids = object.my_channels.pluck(:id) + object.channel_permissions.pluck(:channel_id) + project_channels.pluck(:channel_id)
      Channel.where(id: channel_ids, is_enable: true)
    end

  end
end
