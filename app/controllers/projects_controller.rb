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

  def update_sms_setting
    @project_with_role = current_user.accessible_project(params[:id])
    if valid_params?
      @project_with_role.object.update_attributes(filter_params.except("channel_ids"))
      channel_ids = filter_params[:channel_ids]
      channel_accesses = @project_with_role.object.channel_accesses
      #reset channel_accesses
      channel_accesses.update_all(is_active: false)
      channel_ids.each do |c_id|
        channel_access = channel_accesses.select { |c| c.channel_id == c_id.to_i }.first
        if channel_access
          channel_access.update_attributes(is_active: true)
        else
          ChannelAccess.create(project_id: @project_with_role.object.id, channel_id: c_id, is_active: true)
        end
      end
      redirect_to projects_path, notice: 'Project updated'
    else
      redirect_to sms_setting_project_path, :flash => { :alert => "Please enter all required fields." }
    end
  end

  def list
    @projects = Project.query_by_user(params[:user_id])
    @projects = @projects.from_query(params[:project_name])
    render json: @projects
  end

  private

  def filter_params
    params.require(:project).permit(:name, :description, :sms_alert_started_at, :sms_alert_ended_at, :sms_alert_template, channel_ids: [])
  end

  def valid_params?
    filter_params[:channel_ids].present? && filter_params[:sms_alert_started_at].present? && filter_params[:sms_alert_ended_at].present? && filter_params[:sms_alert_template].present?
  end
end