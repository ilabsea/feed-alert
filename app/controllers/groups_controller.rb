class GroupsController < ApplicationController

  before_action :load_group, only: [:edit, :update, :destroy, :new_members]
  def index
    @groups = current_user.groups.order('groups.name').page(params[:page])
  end

  def new_members
    existing_members = @group.members.ids

    members = Member.all
    members = members.excludes(existing_members) if existing_members.count > 0
    members = members.from_query(params[:q]) if params[:q].present?
    render json: members
  end

  def new
    @group = current_user.groups.build
  end

  def create
    @group = current_user.groups.build(filter_params)
    if @group.save
      redirect_to edit_group_path(@group), notice: 'Group has been created'
    else
      flash.now[:alert] = 'Failed to create group'
      render :new
    end
  end

  def edit
  end

  def update
    if(@group.update_attributes(filter_params))
      redirect_to groups_path, notice: 'Group has been updated'
    else
      flash.now[:alert] = 'Failed to update'
      render :edit
    end
  end

  def destroy
    if(@group.destroy)
      redirect_to groups_path, notice: 'Group has been deleted'
    else
      redirect_to groups_path, alert: "Failed to delete the group"
    end
  end

  private
  def load_group
    @group ||= current_user.groups.find(params[:id])
  end

  def filter_params
    params.require(:group).permit(:name, :description)
  end

end