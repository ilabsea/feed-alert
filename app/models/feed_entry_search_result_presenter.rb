class FeedEntrySearchResultPresenter
  attr_accessor :response
  def initialize(response)
    @response = response
  end

  def total
    @response["hits"]["total"]
  end

  def facets
    # { "alert_id_counts"=> { "_type"=>"terms", "missing"=>0, "total"=>2, "other"=>0, "terms"=>[{"term"=>4, "count"=>1}, {"term"=>1, "count"=>1}]}}}
    @response["facets"]
  end

  def terms
    @response["facets"]["alert_id_counts"]["terms"]
  end

  def results
    return @results if @results

    @results = @response["hits"]["hits"].map do |hit|
      hit.slice("_source", "highlight") 
    end
    @results
  end

  def results_by_alert(alert_id)
    results.select{|match_item| match_item["_source"]["alert_id"] == alert_id }
  end

  def alerts
   return @alerts if @alerts
   # [{"term"=>1, "count"=>54}, {"term"=>4, "count"=>6}, {"term"=>2, "count"=>6}]
   alert_ids = terms.map{|item| item["term"] }
   @alerts = Alert.includes([ :keywords , groups: :members ] ).find(alert_ids)

   @alerts.each do |alert|
     match_item = terms.select{|item| item['term']== alert.id}.first
     alert.total_match = match_item["count"]
   end
   @alerts
  end


end