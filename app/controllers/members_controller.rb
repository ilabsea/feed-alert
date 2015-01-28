class MembersController < ApplicationController
  def index
    @members = Member.order('full_name')
    @members = @members.from_query(params[:q]) if params[:q]
    @members = @members.page(params[:page])
  end

  def new
    @member = Member.new
  end

  def new_groups
    member = Member.find(params[:id])
    existing_groups = member.groups.map(&:id)

    groups = Group.all
    groups = groups.excludes(existing_groups) if existing_groups.count > 0
    groups = groups.from_query(params[:q]) if params[:q].present?
    render json: groups
  end

  def create
    @member = Member.new(filter_params)
    if @member.save
      redirect_to edit_member_path(@member), notice: 'Member has been created'
    else
      flash.now[:alert] = 'Failed to create member'
      render :new
    end
  end

  def edit
    @member = Member.includes(:memberships, :groups).find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if(@member.update_attributes(filter_params))
      redirect_to members_path, notice: 'Member has been updated'
    else
      flash.now[:alert] = 'Failed to update'
      render :edit
    end
  end

  def destroy
    @member = Member.find(params[:id])
    if(@member.destroy)
      redirect_to members_path, notice: 'Member has been deleted'
    else
      redirect_to members_path, alert: "Failed to delete the member"
    end
  end

  private
  def filter_params
    params.require(:member).permit(:full_name, :email, :phone, :email_alert, :sms_alert)
  end

end