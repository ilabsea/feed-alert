class AlertsController < ApplicationController
  before_action :require_project_admin_role!, only: [:new, :create, :update, :destroy]
  before_action :check_channel_access!, only: [:create, :update]

  def new_groups
    alert = Alert.find(params[:id])
    existing_groups = alert.groups.ids

    groups = current_user.my_groups
    groups = groups.excludes(existing_groups) if existing_groups.length > 0
    groups = groups.from_query(params[:q]) if params[:q].present?
    render json: groups
  end

  def new_keywords
    alert = Alert.find(params[:id])
    existing_keywords = alert.keywords.ids

    keywords = current_user.keyword_sets
    keywords = keywords.excludes(existing_keywords) if existing_keywords.length > 0
    keywords = keywords.from_query(params[:q]) if params[:q].present?
    render json: keywords
  end

  def index
    @alerts = project_with_role.object.alerts
                                      .includes(:keywords, groups: :alert_groups)
                                      .order('updated_at DESC')
                                      .page(params[:page])
  end

  def new
    @alert = project_with_role.object.alerts.build
  end

  def create
    @alert = project_with_role.object.alerts.build(filter_params)

    if(@alert.save)
      redirect_to edit_project_alert_path(project_with_role.object, @alert), notice: 'Alert has been created'
    else
      flash.now[:alert] = 'Failed to create alert'
      render :new
    end
  end

  def edit
    @alert = project_with_role.object.alerts.includes(:groups, :keywords).find(params[:id])
  end

  def update
    @alert = project_with_role.object.alerts.find(params[:id])
    @alert.reset_error

    if(@alert.update_attributes(filter_params))
      redirect_to project_alerts_path(project_with_role.object), notice: 'Alert has been updated'
    else
      flash.now[:alert] = 'Could not save the alert'
      render :edit
    end
  end

  def destroy
    @alert = project_with_role.object.alerts.find(params[:id])
    if @alert.destroy
      redirect_to project_alerts_path(project_with_role.object), notice: 'Alert has been deleted'
    else
      redirect_to project_alerts_path(project_with_role.object), notice: 'Could not delete the alert'
    end
  end

  private
  def require_project_admin_role!
    project_with_role.has_admin_role!
  end

  def filter_params
    params.require(:alert).permit(:name, :url, :interval, :from_time, :to_time, :sms_template, :channel_id,
                                  alert_places_attributes: [:id, :place_id, :_destroy])
  end

  def check_channel_access!
    current_user.accessible_channel(params[:alert][:channel_id]) if params[:alert][:channel_id].present?
  end

  def project_with_role
    @project_with_role ||= current_user.accessible_project(params[:project_id])
  end

end