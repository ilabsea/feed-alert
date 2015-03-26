require 'rails_helper'

RSpec.describe FeedEntry, :type => :model do
  describe '.apply_search' do
    let(:content) {
      content = <<-eos
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute 
        irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        deserunt mollit anim id est laborum.
      eos
    }
    context 'keywords matched again content' do
      it 'marks matched to true' do
        allow_any_instance_of(FeedEntry).to receive(:process_url)

        feed_entry = create(:feed_entry, content: content, keywords: ['ullamco', 'adipisicing', 'dolore'])
        feed_entry.apply_search
        
        
        expect(feed_entry.matched).to eq true
      end
    end

    context 'keywords does not matched to content' do
      it 'marks matched to false' do
        allow_any_instance_of(FeedEntry).to receive(:process_url)

        feed_entry = create(:feed_entry, content: content, keywords: ['google', 'technology'])
        feed_entry.apply_search
        expect(feed_entry.matched).to eq false
      end

    end

  end
end
