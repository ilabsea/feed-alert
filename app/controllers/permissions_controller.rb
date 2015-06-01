class PermissionsController < ApplicationController
  def index
    @projects = current_user.my_projects.order('name')
    @shared_users = @projects.shared_users
  end
end