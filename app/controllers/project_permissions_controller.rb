class ProjectPermissionsController < ApplicationController
  def create
    permission = PerformPermission.new(current_user).for_project(params)
    head :ok
  end
end