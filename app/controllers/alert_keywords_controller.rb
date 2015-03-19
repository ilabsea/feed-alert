class AlertKeywordsController < ApplicationController
  def create
    alert = Alert.find(params[:alert_id])
    keyword = Keyword.where(name: params[:keyword_name]).first_or_initialize
    keyword.save!

    alert_keyword = alert.alert_keywords.build(keyword_id: keyword.id)

    if alert_keyword.save
      render json: alert.keywords
    else
      render json: alert_keyword.errors.full_messages.first, status: 422
    end
  end
end