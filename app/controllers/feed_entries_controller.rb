class FeedEntriesController < ApplicationController
  def index
    @alert = Alert.find(params[:alert_id])
    from = params[:from]
    to  = params[:to]
    @date_range = DateRange.new(from, to)
    @feed_entries = @alert.feed_entries.matched.between(@date_range).page(params[:page])
  end

  def show
    from = params[:from]
    to  = params[:to]
    @date_range = DateRange.new(from, to)
    @alert = Alert.find(params[:alert_id])
    @feed_entry = FeedEntry.find(params[:id])
  end

end