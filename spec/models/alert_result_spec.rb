require 'rails_helper'

RSpec.describe AlertResult, type: :model do
  include ActiveJob::TestHelper

  let(:project) {create(:project)}
  let(:channel) { build(:channel) }
  let!(:alert) {create(:alert, project: project)}
  let!(:group) {create(:group)}

  let!(:member1) { create(:member, full_name: "test1", phone: "85510000000", email: "foo@example.com") }
  let!(:member2) { create(:member, full_name: "test2", phone: "85520000000", email: "bar@example.com") }

  let!(:membership1) { create(:membership, member: member1, group: group) }
  let!(:membership2) {create(:membership, member: member2, group: group)}

  let!(:alert_group) {create(:alert_group, alert: alert, group: group)}
  let!(:alert_result) {AlertResult.new([alert])}

  describe "#run" do
    before(:each) do
      allow(alert).to receive(:has_match?).and_return(true)

      running_time = Time.now
      Timecop.freeze(running_time)

      allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('85510000000').and_return(channel)
      allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('85520000000').and_return(channel)
      allow(alert).to receive(:translate_message).and_return('')
      allow(project).to receive(:time_appropiate?).with(running_time).and_return(true)

      allow(alert_result).to receive(:delay_time).and_return(1)
      allow(alert_result).to receive(:alert_highlight).with(alert.id).and_return(
        {"_index"=>"feed_entries", "_type"=>"feed_entry", "_id"=>"foo", "_score"=>0.0922051,
          "_source"=>{
                      "title"=>"Foo Bar", "keywords"=>["foo", "bar"],
                      "url"=>"http://www.cnn.com/2016/07/13/politics/boris-johnson-us-politicians/index.html",
                      "alert_id"=>alert.id
                    }
        }
      )
      allow_any_instance_of(FeedEntrySearchResultPresenter).to receive(:alerts).and_return([alert])
    end

    it "enqueue the alert" do
      alert_result.run
      expect(enqueued_jobs.size).to eq(1)
    end
  end

  describe "#alert" do
    before(:each) do
      allow(alert).to receive(:has_match?).and_return(true)
    end

    context "sms" do
      before(:each) do
        running_time = Time.now
        Timecop.freeze(running_time)

        allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('85510000000').and_return(channel)
        allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('85520000000').and_return(channel)
        allow(alert).to receive(:translate_message).and_return('')
        allow(project).to receive(:time_appropiate?).with(running_time).and_return(true)
      end

      after(:each) do
        Timecop.return
      end

      it "Add a sms queue with every numbers" do
        alert_result.alert_sms(alert)
        expect(enqueued_jobs.size).to eq(1)
      end
    end
  end

  describe "#receivers_of" do
    it "return a list of phone number" do
      receivers = alert_result.receivers_of(group, :sms)
      expect(receivers).to contain_exactly('85510000000', '85520000000')
    end

    it "return a list of email" do
      receivers = alert_result.receivers_of(group, :email)
      expect(receivers).to contain_exactly('foo@example.com', 'bar@example.com')
    end
  end

  describe "#messages_of" do
    it "return a list of message" do
      allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('85510000000').and_return(channel)

      messages = alert_result.messages_of('test', ['85510000000'], project)
      expect(messages.size).to eq 1
      expect(messages.first).to be_a_kind_of(Message)
    end
  end

end
