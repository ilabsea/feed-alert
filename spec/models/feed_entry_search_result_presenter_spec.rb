require 'rails_helper'

RSpec.describe FeedEntrySearchResultPresenter, type: :model do
  let!(:search_result) { FeedEntrySearchResultPresenter.new(
                                                              {"hits"=>
                                                                  {"total"=>2,
                                                                   "hits"=>
                                                                    [{"_index"=>"feed_entries",
                                                                      "_type"=>"feed_entry",
                                                                      "_id"=>"AVIuhR2jd6Jj8nutJGrS"
                                                                     },
                                                                     {"_index"=>"feed_entries",
                                                                      "_type"=>"feed_entry",
                                                                      "_id"=>"AVIuhJrxd6Jj8nutJGrF"
                                                                      }
                                                                    ]
                                                                  }
                                                              }
                                                          )
                      }
  describe '#total' do
    it {
      expect(search_result.total).to eq 2
    }
  end

  describe '#alerts' do
    let!(:alert) { create(:alert, url: 'http://foo.com') }

    before(:each) do
      allow(search_result).to receive(:terms).and_return([{"term" => alert.id, "count" => 20}])
    end

    it {
      expect(search_result.alerts).to include(alert)
    }
  end

  describe '#feed_entries' do
    it {
      expect(search_result.feed_entries).to eq ["AVIuhR2jd6Jj8nutJGrS", "AVIuhJrxd6Jj8nutJGrF"]
    }
  end
end
