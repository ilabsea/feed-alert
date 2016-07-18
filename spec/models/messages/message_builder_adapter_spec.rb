require 'rails_helper'

RSpec.describe Messages::MessageBuilderAdapter, type: :model do
  describe "build" do
    let(:channel){ create(:channel)}

    context "alert" do
      let(:project) { build(:project) }
      let(:message_builder) { Messages::Builder::AlertMessageBuilder.new('test', ['8551000'], project) }
      let(:adapter) { Messages::MessageBuilderAdapter.new(message_builder) }

      before(:each) do
        allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('8551000').and_return(channel)
      end

      it { expect(adapter.suggested_channel).to be_a_kind_of(Channels::ChannelSuggested) }

      it "return a list of message" do
        messages = adapter.build
        expect(messages.size).to eq 1
        expect(messages.first).to be_a_kind_of(Message)
      end
    end

    context "group message" do
      let(:user) { build(:user) }
      let(:message_builder) { Messages::Builder::AlertMessageBuilder.new('test', ['8551000'], user) }
      let(:adapter) { Messages::MessageBuilderAdapter.new(message_builder) }

      before(:each) do
        allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('8551000').and_return(channel)
      end

      it { expect(adapter.suggested_channel).to be_a_kind_of(Channels::ChannelSuggested) }

      it "return a list of message" do
        messages = adapter.build
        expect(messages.size).to eq 1
        expect(messages.first).to be_a_kind_of(Message)
      end
    end

    context "no suggested channel" do
      let(:user) { build(:user) }
      let(:message_builder) { Messages::Builder::AlertMessageBuilder.new('test', ['8551000'], user) }
      let(:adapter) { Messages::MessageBuilderAdapter.new(message_builder) }

      before(:each) do
        allow(adapter).to receive(:suggested_channel).and_return(nil)
      end

      it { expect(adapter.suggested_channel).to eq(nil) }

      it "raise UnknownChannelException when there is no any suggeted channel" do
        expect { adapter.build }.to raise_error(Errors::UnknownChannelException)
      end
    end
  end

end
