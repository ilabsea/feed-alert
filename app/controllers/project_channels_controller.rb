class ProjectChannelsController < ApplicationController

  before_action :require_admin
  
  def index
    if params[:user_email]
      projects = Project.joins(:user).where('users.email' => params[:user_email]).group('users.email', 'name')
    else
      projects = Project.joins(:user).group('users.email', 'name')
    end

    project_ids = projects.map(&:id)
    project_channels = ProjectChannel.where(project_id: project_ids)
    @rows = []
    @project_channel = ProjectChannel.new
    projects.each_with_index do |project, i|
      row = []
      row << project.user
      row << project
      national_gateway_channels.each_with_index do |national_channel, j|
        row << project_channels.select{ |project_channel| project_channel.project_id == project.id && project_channel.channel_id == national_channel.id}.first
      end
      @rows << row
    end

  end

  def create
    @project_channel = Project.find(filter_params[:project_id])
    if @project_channel.update_attributes(channel_ids: filter_params[:channel_id])
      redirect_to project_channels_path, notice: 'Project updated'
    else
      flash.now[:alert] = "Failed to update project"
      render :edit
    end    
  end

  def new
    @project_channel = ProjectChannel.new
  end

  def edit
    
  end

  private
  def filter_params
    params.require(:project_channel).permit(:project_id, channel_id: [])
  end

end