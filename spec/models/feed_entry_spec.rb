require 'rails_helper'

RSpec.describe FeedEntry, type: :model do

  describe 'create' do
    describe 'validate unique title with url scope' do
      context 'with different title, url' do
        it 'create record and return true' do
          new_feed_entry = build(:feed_entry, title: 'pppost', url: 'http://ppp.com/ptime11')
          feed_entry = new_feed_entry.save
          expect(feed_entry["created"]).to eq true
        end
      end

      context 'duplicate title with url scope' do
        it 'does not create record and return false' do
          new_feed_entry = build(:feed_entry, title: 'pppost', url: 'http://ppp.com/main')
          result = new_feed_entry.save
          expect(result["created"]).to eq true
        end
      end
    end

  end
end
