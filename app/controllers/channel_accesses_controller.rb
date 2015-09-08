class ChannelAccessesController < ApplicationController

  before_action :require_admin
  
  def index
    if params[:user_email]
      @projects = Project.joins(:user).where('users.email' => params[:user_email]).group('users.email', 'name')
    else
      @projects = Project.joins(:user).group('users.email', 'name')
    end
  end

  def create
    @project_with_role = current_user.accessible_project(params[:project][:id])
    @project_with_role.has_admin_role!
    if @project_with_role.update_attributes(filter_params)
      redirect_to channel_accesses_path, notice: 'Project is granted access to the national gateway'
    else
      redirect_to channel_accesses_path, alert: 'Fialed to grant access to national gateway'
    end
  end

  private
  def filter_params
    params.require(:project).permit(:is_enabled_national_gateway)
  end

end