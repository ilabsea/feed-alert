# @response=
  # {"took"=>101,
  #  "timed_out"=>false,
  #  "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0},
  #  "hits"=>
  #   {"total"=>20,
  #    "max_score"=>0.116118275,
  #    "hits"=>
  #     [{"_index"=>"feed_entries",
  #       "_type"=>"feed_entry",
  #       "_id"=>"AVIuhR2jd6Jj8nutJGrS",
  #       "_score"=>0.116118275,
  #       "_source"=>
  #        {"title"=>"Frutarom invests in algae startup for food, cosmetic products",
  #         "keywords"=>["drug", "emergency", "startup", "environment"],
  #         "created_at"=>"2016-01-11T02:30:21.852Z",
  #         "url"=>
  #          "http://reuters.us.feedsportal.com/c/35217/f/654220/s/4ca2a6df/sc/28/l/0L0Sreuters0N0Carticle0Cus0Efrutarom0Einds0Ealgae0EidUSKBN0AUI0AP520A160A10A40DfeedType0FRSS0GfeedName0FscienceNews/story01.htm",
  #         "alert_id"=>31},
  #       "highlight"=>
  #        {"content"=>
  #          ["                          \n\t\n                                                       <em class='highlight'>Environment</em>\n                                                    \n\t\n                             ",
  #           "         \n                Science, \n                <em class='highlight'>Environment</em>\n                \n        \n\n    Frutarom invests in algae <em class='highlight'>startup</em> for food, cosmetic products\n\n                \n     "],
  #         "title"=>["Frutarom invests in algae <em class='highlight'>startup</em> for food, cosmetic products"]}},
  #      {"_index"=>"feed_entries",
  #       "_type"=>"feed_entry",
  #       "_id"=>"AVIuhJrxd6Jj8nutJGrF",
  #       "_score"=>0.01754997,
  #       "_source"=>
  #        {"title"=>"Illumina, partners make $100 million bet to detect cancer via blood test",
  #         "keywords"=>["drug", "emergency", "startup", "environment"],
  #         "created_at"=>"2016-01-11T02:29:48.391Z",
  #         "url"=>
  #          "http://reuters.us.feedsportal.com/c/35217/f/654220/s/4cc53781/sc/28/l/0L0Sreuters0N0Carticle0Cus0Eusa0Ehealthcare0Eillumina0EidUSKCN0AUO0AW920A160A1110DfeedType0FRSS0GfeedName0FscienceNews/story01.htm",
  #         "alert_id"=>31},
  #       "highlight"=>
  #        {"content"=>
  #          ["                          \n\t\n                                                       <em class='highlight'>Environment</em>\n                                                    \n\t\n                             ",
  #           "diagnosed with cancer to see how they are responding to treatment or to check for mutations or <em class='highlight'>drug</em> resistance.\n\n\n        \n        Critics said there is not enough evidence yet that a blood"]}},

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
    @results = @response["hits"]["hits"]
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