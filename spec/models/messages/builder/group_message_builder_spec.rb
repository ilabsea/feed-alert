require 'rails_helper'

RSpec.describe Messages::Builder::GroupMessageBuilder, type: :model do

  describe "#channel_suggested" do
    let(:message_builder) { Messages::Builder::GroupMessageBuilder.new('Message', ['1000'], build(:project)) }

    it { expect(message_builder.channel_suggested).to be_a_kind_of(Channels::ChannelSuggested) }
  end
end
