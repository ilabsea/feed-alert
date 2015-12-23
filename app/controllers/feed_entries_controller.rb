class FeedEntriesController < ApplicationController
  def matched
    @alert = Alert.find(params[:alert_id])
    search_options = SearchOption.for_old_feed_entries([@alert])

    search_result = FeedEntry.search(search_options)
    @search_highlight = search_result.results
  end

  def show
    from = params[:from]
    to  = params[:to]
    @alert = Alert.find(params[:alert_id])
    @feed_entry = FeedEntry.find(params[:id])
  end

  def embed
    @alert = Alert.find(params[:alert_id])
    @feed_entry = FeedEntry.find(params[:id])
    render layout: false
  end
end