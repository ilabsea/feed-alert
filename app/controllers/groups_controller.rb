class GroupsController < ApplicationController
  def index
    @groups = Group.page(params[:page])
  end

  def new_members
    group = Group.find(params[:id])
    existing_members = group.members.map(&:id)

    members = Member.all
    members = members.excludes(existing_members) if existing_members.count > 0
    members = members.from_query(params[:q]) if params[:q].present?
    render json: members
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(filter_params)
    if @group.save
      redirect_to edit_group_path(@group), notice: 'Group has been created'
    else
      flash.now[:alert] = 'Failed to create group'
      render :new
    end
  end

  def edit
    @group = Group.includes(:memberships, :members).find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if(@group.update_attributes(filter_params))
      redirect_to groups_path, notice: 'Group has been updated'
    else
      flash.now[:alert] = 'Failed to update'
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if(@group.destroy)
      redirect_to groups_path, notice: 'Group has been deleted'
    else
      redirect_to groups_path, alert: "Failed to delete the group"
    end
  end

  private
  def filter_params
    params.require(:group).permit(:name, :description)
  end

end