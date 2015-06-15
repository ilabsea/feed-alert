class GroupsController < ApplicationController

  def index
    @groups = current_user.groups.includes(memberships: :member, alert_groups: [alert: :project]).order('groups.name').page(params[:page])
    @group_permissions = current_user.high_level_group_permissions.includes(:alert, :project, group: [{memberships: :member}]).page(params[:shared_page])
  end

  def new_members

    existing_members = group_with_role.object.members.ids

    members = current_user.members
    members = members.excludes(existing_members) if existing_members.count > 0
    members = members.from_query(params[:q]) if params[:q].present?
    render json: members
  end

  def new
    group = current_user.groups.build
    @group_with_role = ObjectWithRole.new(group)
  end

  def create
    group = current_user.groups.build(filter_params)
    @group_with_role = ObjectWithRole.new(group)
  
    if @group_with_role.save
      redirect_to edit_group_path(@group_with_role.object), notice: 'Group has been created'
    else
      flash.now[:alert] = 'Failed to create group'
      render :new
    end
  end

  def edit
    group_with_role
  end

  def update
    group_with_role.has_admin_role!
    if(group_with_role.update_attributes(filter_params))
      redirect_to groups_path, notice: 'Group has been updated'
    else
      flash.now[:alert] = 'Failed to update'
      render :edit
    end
  end

  def destroy
    group_with_role.has_admin_role!
    if(group_with_role.destroy)
      redirect_to groups_path, notice: 'Group has been deleted'
    else
      redirect_to groups_path, alert: "Failed to delete the group"
    end
  end

  def alerts
    @group = group_with_role.object
    render layout: false
  end

  private
  def group_with_role
    @group_with_role ||= current_user.accessible_group(params[:id])
  end

  def filter_params
    params.require(:group).permit(:name, :description)
  end

end