module Channels::Accessible
  class UserChannelAccessible < ChannelAccessible
    def initialize user
      @user = user
    end

    def list
      admin_project_ids = @user.project_with_admin_permission.pluck(:id)
      project_channels = ChannelAccess.where(project_id: admin_project_ids)
      channel_ids = @user.my_channels.pluck(:id) + @user.channel_permissions.pluck(:channel_id) + project_channels.pluck(:channel_id)
      Channel.where(id: channel_ids, is_enable: true)
    end

  end
end
