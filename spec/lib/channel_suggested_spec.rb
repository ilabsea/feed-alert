require 'rails_helper'

describe ChannelSuggested, :type => :model do

  describe '.by_phone' do

    let(:camgsm){create(:national_channel, name: 'camgsm')}
    let(:smart){create(:national_channel, name: 'smart')}
    let(:basic_channel){create(:basic_channel)}
    let(:advance_channel){create(:advance_channel)}

    context 'with national channels accessing' do
      context 'when the tel carrier matches the national channels ' do
        it 'return tel carrier match with national channel match' do
          channel_suggested = ChannelSuggested.new([basic_channel, advance_channel, camgsm, smart])
          expect(channel_suggested.by_phone "85510999999").to eq smart
          expect(channel_suggested.by_phone "093999999").to eq smart
          expect(channel_suggested.by_phone "+85517999999").to eq camgsm
          expect(channel_suggested.by_phone "855092999999").to eq camgsm
        end
      end

      context 'when the tel carrier does not match the national channels ' do
        it 'return the first channel' do
          channel_suggested = ChannelSuggested.new([camgsm, smart, basic_channel, advance_channel])
          expect(channel_suggested.by_phone "85513999999").to eq camgsm
          expect(channel_suggested.by_phone "+85597999999").to eq camgsm
        end      
      end
    end

    context 'without national channels accessing' do
      it 'return the first channel' do
        channel_suggested = ChannelSuggested.new([basic_channel, advance_channel])
        expect(channel_suggested.by_phone "85510999999").to eq basic_channel
        expect(channel_suggested.by_phone "+85517999999").to eq basic_channel
      end      
    end

    context 'with no channels accessing' do
      it 'return nil' do
        channel_suggested = ChannelSuggested.new([])
        expect(channel_suggested.by_phone "85510999999").to be_nil
      end
    end
  end

end