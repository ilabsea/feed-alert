class AlertGroupsController < ApplicationController
  def create
    alert = Alert.find(params[:alert_id])
    alert_group = alert.alert_groups.build(group_id: params[:group_id])
    if alert_group.save
      render json: alert.groups
    else
      render json: alert_group.errors.full_messages.first, status: 422
    end
  end
end