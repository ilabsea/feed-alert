class ProjectsController < ApplicationController
  def index
    @my_projects = current_user.my_projects.page(params[:page])
    @shared_projects = current_user.shared_projects.page(params[:page])
  end

  def new
    @project = current_user.my_projects.build
  end

  def create
    @project = current_user.my_projects.build(filter_params)
    if @project.save
      redirect_to projects_path, notice: 'Project has been created'
    else
      flash.now[:alert] = "Failed to create project"
      render :new
    end
  end

  def edit
    @project = current_user.my_projects.find(params[:id])
  end

  def update
    @project = current_user.my_projects.find(params[:id])
    if @project.update_attributes(filter_params)
      redirect_to projects_path, notice: 'Project updated'
    else
      flash.now[:alert] = "Failed to update project"
      render :edit
    end
  end

  def destroy
    @project = current_user.my_projects.find(params[:id])
    if @project.destroy
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