class AlertKeywordsController < ApplicationController
  def create
    @alert = Alert.find(params[:alert_id])
    keyword = current_user.keyword_sets.find_by(name: params[:keyword].strip)

    alert_keyword = AlertKeywordSet.new(keyword_set: keyword, alert: @alert)

    if alert_keyword.save
      render layout: false
    else
      render text: alert_keyword.errors.full_messages.first, status: 422
    end
  end

  def destroy
    alert_keyword = AlertKeywordSet.find(params[:id])
    alert_keyword.destroy
    head :ok
  end
end