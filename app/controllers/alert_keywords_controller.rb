class AlertKeywordsController < ApplicationController
  def create
    @alert = Alert.find(params[:alert_id])
    keyword = Keyword.find_or_create_by(name: params[:keyword].strip)
    if !keyword.persisted?
      render text: keyword.errors.full_messages.first, status: 422
      return
    end

    alert_keyword = @alert.alert_keywords.build(keyword_id: keyword.id)

    if alert_keyword.save
      render layout: false
    else
      render text: alert_keyword.errors.full_messages.first, status: 422
    end
  end

  def destroy
    alert_keyword = AlertKeyword.find(params[:id])
    alert_keyword.destroy
    head :ok
  end
end