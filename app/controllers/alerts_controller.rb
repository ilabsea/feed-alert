class AlertsController < ApplicationController
  def new_groups
    alert = Alert.find(params[:id])
    existing_groups = alert.groups.ids

    groups = Group.all
    groups = groups.excludes(existing_groups) if existing_groups.length > 0
    groups = groups.from_query(params[:q]) if params[:q].present?
    render json: groups
  end

  def new_keywords
    alert = Alert.find(params[:id])
    existing_keywords = alert.keywords.ids

    keywords = Keyword.all
    keywords = keywords.excludes(existing_keywords) if existing_keywords.length > 0
    keywords = keywords.from_query(params[:q]) if params[:q].present?
    render json: keywords
  end

  def matched
    from = params[:from] || Time.zone.now-7.days
    to   = params[:to] || Time.zone.now
    @date_range = DateRange.new(from, to)

    alerts_for_options = Alert.includes(:keywords).all

    search_options = Alert.search_options(alerts_for_options, @date_range)
    search_highlight = FeedEntry.search(search_options)
    @alerts = search_highlight.alerts
  end

  def index
    @alerts = Alert.includes(:keywords).order('created_at DESC').page(params[:page])
  end

  def new
    @alert = Alert.new
  end

  def create
    @alert = Alert.new(filter_params)

    if(@alert.save)
      redirect_to edit_alert_path(@alert), notice: 'Alert has been created'
    else
      flash.now[:alert] = 'Failed to create alert'
      render :new
    end
  end

  def edit
    @alert = Alert.find(params[:id])
  end

  def update
    @alert = Alert.find(params[:id])
    if(@alert.update_attributes(filter_params))
      redirect_to alerts_path, notice: 'Alert has been updated'
    else
      flash.now[:alert] = 'Could not save the alert'
      render :edit
    end
  end

  def destroy
    @alert = Alert.find(params[:id])
    if @alert.destroy
      redirect_to alerts_path, notice: 'Alert has been deleted'
    else
      redirect_to alerts_path, notice: 'Could not delete the alert'
    end
  end

  private
  def filter_params
    params.require(:alert).permit(:name, :url, :interval, :from_time, :to_time, :sms_template, 
                                  alert_places_attributes: [:id, :place_id, :_destroy],)
  end

end