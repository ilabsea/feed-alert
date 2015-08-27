require 'rails_helper'

RSpec.describe FeedEntry, type: :model do
  before(:each) do
    # FeedEntry.any_instance.stub(:sync_index)
    allow_any_instance_of(FeedEntry).to receive(:sync_index)
  end
  describe 'create' do
    before(:each) { create(:feed_entry, title: 'pppost', url: 'http://ppp.com/main') }
    describe 'validate unique title with url scope' do
      context 'with different title, url' do
        it 'create record and return true' do
          new_feed_entry = build(:feed_entry, title: 'pppost', url: 'http://ppp.com/ptime11')
          expect(new_feed_entry.save).to eq true
        end
      end

      context 'duplicate title with url scope' do
        it 'does not create record and return false' do
          new_feed_entry = build(:feed_entry, title: 'pppost', url: 'http://ppp.com/main')
          result = new_feed_entry.save
          expect(result).to eq false
        end
      end
    end

  end
end