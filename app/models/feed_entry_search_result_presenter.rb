class FeedEntrySearchResultPresenter

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

  def results
    @response["hits"]["hits"].map do |hit|
      hit.slice("fields", "highlight") 
    end
  end
end