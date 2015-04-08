class FeedEntriesController < ApplicationController
  def index
    @alert = Alert.find(params[:alert_id])
    @feed_entries = @alert.feed_entries

    if params[:from].present?
      from = params[:from]
      to  = params[:to]
      @date_range = DateRange.new(from, to)
      @feed_entries = @feed_entries.matched.between(@date_range)
    end
    @feed_entries = @feed_entries.page(params[:page])

  end

  def show
    from = params[:from]
    to  = params[:to]
    @date_range = DateRange.new(from, to)
    @alert = Alert.find(params[:alert_id])
    @feed_entry = FeedEntry.find(params[:id])
  end
end

#['standalone server',  'ILI/ARI sentinel system', 'rhinovirus/enterovirus–positive', 'parameter to the url', 'Learning Erlang']