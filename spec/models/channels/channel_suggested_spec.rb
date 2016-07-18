require 'rails_helper'

describe Channels::ChannelSuggested, :type => :model do
  let(:smart) {create(:national_channel, name: 'smart', is_enable: true)}
  let(:camgsm) {create(:national_channel, name: 'camgsm', is_enable: true)}

  describe ".suggested" do
    context "project" do
      let(:project) {build(:project)}
      let(:channel_accessible) { Channels::Accessible::ProjectChannelAccessible.new(project) }
      let(:channel_suggested) { Channels::ChannelSuggested.new(channel_accessible) }
      context "when channels connected" do
        before(:each) do
          allow(channel_accessible).to receive(:list).and_return([smart, camgsm])
        end

        context "when phone prefix matches with carrier" do
          it { expect(channel_suggested.suggested('+85512345678')).to eq(camgsm) }
          it { expect(channel_suggested.suggested('85510345678')).to eq(smart) }
        end

        context "when phone prefix does match with carrier" do
          it { expect(channel_suggested.suggested('977345678')).to eq(smart) }
        end
      end

      context "when channel does not connected" do
        before(:each) do
          allow(channel_accessible).to receive(:list).and_return([])
        end

        it { expect(channel_suggested.suggested('12345678')).to eq(nil) }
        it { expect(channel_suggested.suggested('010345678')).to eq(nil) }
        it { expect(channel_suggested.suggested('0977345678')).to eq(nil) }
      end
    end

    context "user" do
      let!(:user) {build(:user)}
      let!(:channel) { create(:channel, user: user) }
      let(:channel_accessible) { Channels::Accessible::UserChannelAccessible.new(user) }
      let(:channel_suggested) { Channels::ChannelSuggested.new(channel_accessible) }

      before(:each) do
        allow(channel_accessible).to receive(:list).and_return([channel])
      end

      it { expect(channel_suggested.suggested('12345678')).to eq(channel) }
    end
  end
end
