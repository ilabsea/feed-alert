require 'rails_helper'

describe ChannelSuggested, :type => :model do
  context 'without prefix' do
    it { expect(ChannelSuggested.new('012999999').without_prefix).to eq('12999999') }
    it { expect(ChannelSuggested.new('85512999999').without_prefix).to eq('12999999') }
    it { expect(ChannelSuggested.new('+85512999999').without_prefix).to eq('12999999') }
    it { expect(ChannelSuggested.new('855012999999').without_prefix).to eq('12999999') }
    it { expect(ChannelSuggested.new('+855012999999').without_prefix).to eq('12999999') }

    it { expect(ChannelSuggested.new('12999999').without_prefix).to eq('12999999') }
  end

  context 'carrier' do
    it { expect(ChannelSuggested.new('012999999').carrier).to eq('camgsm') }
    it { expect(ChannelSuggested.new('85517999999').carrier).to eq('camgsm') }
    it { expect(ChannelSuggested.new('+85592999999').carrier).to eq('camgsm') }
    it { expect(ChannelSuggested.new('855011999999').carrier).to eq('camgsm') }
    it { expect(ChannelSuggested.new('+855061999999').carrier).to eq('camgsm') }
    it { expect(ChannelSuggested.new('76999999').carrier).to eq('camgsm') }

    it { expect(ChannelSuggested.new('010999999').carrier).to eq('smart') }   
    it { expect(ChannelSuggested.new('85596999999').carrier).to eq('smart') }   
    it { expect(ChannelSuggested.new('+85593999999').carrier).to eq('smart') }   
    it { expect(ChannelSuggested.new('855098999999').carrier).to eq('smart') }   
  end

end