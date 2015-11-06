class ChannelAccessesController < ApplicationController

  before_action :require_admin
  
  def index
    @projects = Project.query_by_user_email(params[:user_email]).page(params[:page])
    @rows = []
    @channel_access = ChannelAccess.new

    project_ids = @projects.map(&:id)
    channel_accesses = ChannelAccess.where(project_id: project_ids)
    
    @projects.each_with_index do |project, i|
      if project.is_accessible_to_national_gateway?
        row = []
        row << project.user
        row << project
        national_gateway_channels.each_with_index do |national_channel, j|
          row << channel_accesses.select{ |channel_access| channel_access.project_id == project.id && channel_access.channel_id == national_channel.id}.first
        end
        @rows << row
      end
    end

  end

  def create
    if valid_params? filter_params
      @project = Project.find(filter_params[:project_id])
      @project.update_attributes(channel_ids: filter_params[:channel_id])
    else
      redirect_to new_channel_access_path, :flash => { :alert => "Please enter the require fields" }
      return
    end
    redirect_to channel_accesses_path, notice: 'Project updated' 
  end

  def national_gateway
    if valid_params? filter_params
      channel_ids = filter_params[:channel_id] 
      @project = Project.find(filter_params[:project_id])
      @project.build_national_gateway_channel_access channel_ids
    else
      redirect_to new_channel_access_path, :flash => { :alert => "Please enter the require fields" }
      return
    end
    redirect_to channel_accesses_path, notice: 'Project updated' 
  end

  def new
    @channel_access = ChannelAccess.new
  end

  def edit
    
  end

  private
  def filter_params
    params.require(:channel_access).permit(:project_id, channel_id: [])
  end

  def valid_params? params
    (!params[:project_id].nil? || params[:project_id] != "")
  end

end