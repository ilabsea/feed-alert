class ChannelAccessesController < ApplicationController

  before_action :require_admin
  
  def index
    if params[:user_email]
      projects = Project.joins(:user).where('users.email' => params[:user_email]).group('users.email', 'name')
    else
      projects = Project.joins(:user).group('users.email', 'name')
    end

    project_ids = projects.map(&:id)
    channel_accesses = ChannelAccess.where(project_id: project_ids)
    @rows = []
    @channel_access = ChannelAccess.new
    projects.each_with_index do |project, i|
      row = []
      row << project.user
      row << project
      national_gateway_channels.each_with_index do |national_channel, j|
        row << channel_accesses.select{ |channel_access| channel_access.project_id == project.id && channel_access.channel_id == national_channel.id}.first
      end
      @rows << row
    end

  end

  def create
    @channel_access = Project.find(filter_params[:project_id])
    if @channel_access.update_attributes(channel_ids: filter_params[:channel_id])
      redirect_to channel_accesses_path, notice: 'Project updated'
    else
      flash.now[:alert] = "Failed to update project"
      render :edit
    end   
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

end