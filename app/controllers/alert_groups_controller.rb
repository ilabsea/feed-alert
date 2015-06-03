class AlertGroupsController < ApplicationController
  def create
    perform_alert_group = PerformAlertGroup.new(params)
    @alert_group = perform_alert_group.create
    
    if @alert_group.valid?
      render layout: false
    else
      render text: @alert_group.errors.full_messages.first, status: 422
    end
  end

  def destroy
    perform_alert_group = PerformAlertGroup.new(params)
    perform_alert_group.destroy
    head :ok
  end
end