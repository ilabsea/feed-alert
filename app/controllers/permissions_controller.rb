class PermissionsController < ApplicationController
  def index
    @projects = current_user.my_projects.order('name')
    @channels = current_user.my_channels.order('created_at')
    @shared_users = current_user.shared.includes(:project_permissions, :channel_permissions)
  end
end