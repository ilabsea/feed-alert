# @response=
#   {"took"=>12,
#    "timed_out"=>false,
#    "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0},
#    "hits"=>
#     {"total"=>5,
#      "max_score"=>0.0150097255,
#      "hits"=>
#       [{"_index"=>"feed_entry-development",
#         "_type"=>"feed_entry",
#         "_id"=>"553",
#         "_score"=>0.0150097255,
#         "_source"=>
#          {"id"=>553,
#           "title"=>"Pfizer pledges to ringfence key new drugs in AstraZeneca deal",
#           "keywords"=>["bussines", "technology", "social", "art", "culture", "gloabl", "news", "deal", "attempt", "sweet"],
#           "created_at"=>"2015-12-23T10:12:01.000+07:00",
#           "url"=>
#            "http://reuters.us.feedsportal.com/c/35217/f/654216/s/3a68b59c/sc/7/l/0L0Sreuters0N0Carticle0C20A140C0A50C140Cus0Eastrazeneca0Epfizer0EidUSBREA3R0AH520A140A5140DfeedType0FRSS0GfeedName0FglobalMarketsNews/story01.htm",
#           "alert_id"=>15},
#         "highlight"=>{"title"=>["Pfizer pledges to ringfence key new drugs in AstraZeneca <em class='highlight'>deal</em>"]}},
#        {"_index"=>"feed_entry-development",
#         "_type"=>"feed_entry",
#         "_id"=>"555",
#         "_score"=>0.013266775,
#         "_source"=>
#          {"id"=>555,
#           "title"=>"Pfizer defends 'powerhouse' Astra deal as CEO braces for grilling",
#           "keywords"=>["bussines", "technology", "social", "art", "culture", "gloabl", "news", "deal", "attempt", "sweet"],
#           "created_at"=>"2015-12-23T10:12:06.000+07:00",
#           "url"=>
#            "http://reuters.us.feedsportal.com/c/35217/f/654216/s/3a50290e/sc/2/l/0L0Sreuters0N0Carticle0C20A140C0A50C120Cus0Eastrazeneca0Epfizer0EidUSBREA3R0AH520A140A5120DfeedType0FRSS0GfeedName0FglobalMarketsNews/story01.htm",
#           "alert_id"=>15},
#         "highlight"=>{"title"=>["Pfizer defends 'powerhouse' Astra <em class='highlight'>deal</em> as CEO braces for grilling"]}}
#        ]
#      }
#    }

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

  def feed_entries
    @response["hits"]["hits"].map do |hit|
      hit["_id"]
    end
  end


end