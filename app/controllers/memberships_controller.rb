class MembershipsController < ApplicationController

  def create
    @group = Group.includes(:memberships).find(params[:group_id])
    membership = @group.memberships.build(member_id: params[:member_id])
    membership.save!
    @group.reload
    render layout: false
  end

  def destroy
    membership = Membership.find(params[:id])
    @group = membership.group
    membership.destroy
    render :create, layout: false

  end


end