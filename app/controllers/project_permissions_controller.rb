class ProjectPermissionsController < ApplicationController

  def create
    permission = PerformPermission.new(current_user).for_project(params)
    render json: permission
  end


  private

end