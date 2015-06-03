class ProjectsController < ApplicationController
  def index
    @my_projects = current_user.my_projects.page(params[:page])
    @shared_projects = current_user.shared_projects.includes(:project_permissions).page(params[:page])
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

    if @project_with_role.update_attributes(filter_params)
      redirect_to projects_path, notice: 'Project updated'
    else
      flash.now[:alert] = "Failed to update project"
      render :edit
    end
  end

  def destroy
    @project_with_role = current_user.accessible_project(params[:id])
    
    # ActiveRecord::StatementInvalid
    if @project_with_role.destroy
      redirect_to projects_path, notice: 'Project has been deleted'
    else
      flash.now[:alert] = "Failed to delete Project"
      render :edit
    end
  end

  private

  def filter_params
    params.require(:project).permit(:name, :description)
  end
end