class MembershipsController < ApplicationController

  def create
    # @group = Group.includes(:memberships).find(params[:group_id])
    @membership = Membership.new(filter_params)
    @membership.save!
    render layout: false

  end

  def destroy
    @membership = Membership.find(params[:id])
    group_with_role = current_user.accessible_group(@membership.group_id)
    group_with_role.has_admin_role!
    @membership.destroy
    head :ok
  end

  def filter_params
    params.permit(:member_id, :group_id)
  end


end