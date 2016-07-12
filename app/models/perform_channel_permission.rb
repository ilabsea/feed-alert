class PerformChannelPermission
  def initialize(user)
    @user = user
  end

  def for_channel(attrs)
    if @user.accessible_channel(attrs[:channel_id]).has_admin_role?
      channel_permission = ChannelPermission.where(user_id: attrs[:user_id], channel_id: attrs[:channel_id]).first_or_initialize
      if channel_permission.id
        channel_permission.destroy! if channel_permission.persisted?
      else
        channel_permission.role = attrs[:role]
        channel_permission.save!
      end
    end
  end

end
