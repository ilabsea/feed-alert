class MembersController < ApplicationController
  def index
    @members = current_user.members.order('full_name')
    @members = @members.from_query(params[:q]) if params[:q]
    @members = @members.page(params[:page])
  end

  def new
    @member = current_user.members.new
  end

  def alerts
    @member = Member.find(params[:id])
    @alerts = Alert.from_member(params[:id])
    render layout: false
  end

  def new_groups
    member = current_user.members.find(params[:id])
    existing_groups = member.groups.ids

    groups = current_user.groups
    groups = groups.excludes(existing_groups) if existing_groups.count > 0
    groups = groups.from_query(params[:q]) if params[:q].present?
    render json: groups
  end

  def create
    @member = current_user.members.new(filter_params)
    if @member.save
      redirect_to edit_member_path(@member), notice: 'Recipient has been created'
    else
      flash.now[:alert] = 'Failed to create recipient'
      render :new
    end
  end

  def edit
    @member = current_user.members.includes(:memberships, :groups).find(params[:id])
  end

  def update
    @member = current_user.members.find(params[:id])
    if(@member.update_attributes(filter_params))
      redirect_to members_path, notice: 'Recipient has been updated'
    else
      flash.now[:alert] = 'Failed to update'
      render :edit
    end
  end

  def destroy
    @member = current_user.members.find(params[:id])
    if(@member.destroy)
      redirect_to members_path, notice: 'Recipient has been deleted'
    else
      redirect_to members_path, alert: "Failed to delete the recipient"
    end
  end

  private
  def filter_params
    params.require(:member).permit(:full_name, :email, :phone, :email_alert, :sms_alert)
  end

end