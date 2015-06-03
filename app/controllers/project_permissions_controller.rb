class ProjectPermissionsController < ApplicationController
  def create
    permission = PerformProjectPermission.new(current_user).for_project(params)
    head :ok
  end
end