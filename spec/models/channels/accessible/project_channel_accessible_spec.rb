require 'rails_helper'

describe Channels::Accessible::ProjectChannelAccessible, :type => :model do
  describe "#list" do
    let!(:project) { create(:project) }
    let!(:smart) { create(:national_channel, is_enable: true) }
    let!(:camgsm) { create(:national_channel, is_enable: true) }

    let!(:channel_access1) { create(:channel_access, project: project, channel: smart, is_active: true) }
    let!(:channel_access2) { create(:channel_access, project: project, channel: camgsm, is_active: true) }

    context "with all connected channels" do
      before(:each) do
        allow_any_instance_of(ChannelNuntium).to receive(:client_connected).and_return(true)
      end

      it { expect(Channels::Accessible::ProjectChannelAccessible.new(project).list).to eq [smart, camgsm] }
    end

    context "with some connected channels" do
      before(:each) do
        channel_nuntium_smart = instance_double("ChannelNuntium", client_connected: true)
        channel_nuntium_camgsm = instance_double("ChannelNuntium", client_connected: false)

        allow(ChannelNuntium).to receive(:new).with(smart).and_return(channel_nuntium_smart)
        allow(ChannelNuntium).to receive(:new).with(camgsm).and_return(channel_nuntium_camgsm)
      end

      it { expect(Channels::Accessible::ProjectChannelAccessible.new(project).list).to eq [smart] }
    end

    context "with no any connected channels" do
      before(:each) do
        allow_any_instance_of(ChannelNuntium).to receive(:client_connected).and_return(false)
      end

      it { expect(Channels::Accessible::ProjectChannelAccessible.new(project).list).to eq [] }
    end
  end

end
