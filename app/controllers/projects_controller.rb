class ProjectsController < ApplicationController
  def index
    @my_projects = current_user.my_projects
                               .page(params[:page])

    @project_permissions = current_user.project_permissions
                                       .includes(:project)
                                       .page(params[:shared_page])
  end

  def new
    @project_with_role = ObjectWithRole.new(current_user.my_projects.build)
  end

  def create
    @project_with_role = ObjectWithRole.new(current_user.my_projects.build(filter_params))
    if @project_with_role.save
      redirect_to projects_path, notice: 'Project has been created'
    else
      flash.now[:alert] = "Failed to create project"
      render :new
    end
  end

  def edit
    @project_with_role = current_user.accessible_project(params[:id])
  end

  def share
    @project_with_role = current_user.shared_projects.find(params[:id])
  end

  def update
    @project_with_role = current_user.accessible_project(params[:id])
    @project_with_role.has_admin_role!

    if @project_with_role.update_attributes(filter_params)
      redirect_to projects_path, notice: 'Project updated'
    else
      flash.now[:alert] = "Failed to update project"
      render :edit
    end
  end

  def destroy
    @project_with_role = current_user.accessible_project(params[:id])
    @project_with_role.has_admin_role!

    begin 
      @project_with_role.destroy
      redirect_to projects_path, notice: 'Project has been deleted'
    rescue ActiveRecord::StatementInvalid => ex
      flash.now[:alert] = "To be able to delete please delete all related records first"
      render :edit
    end
  end

  def sms_setting
    @project_with_role = current_user.accessible_project(params[:id])
  end

  def list
    @projects = Project.where(user_id: params[:user_id])
    @projects = @projects.from_query(params[:project_name])
    render json: @projects
  end

  private

  def filter_params
    params.require(:project).permit(:name, :description, :sms_alert_started_at, :sms_alert_ended_at, :sms_alert_template, channel_ids: [])
  end
end