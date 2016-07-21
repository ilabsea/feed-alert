require 'rails_helper'

describe GroupMessageResult, :type => :model do
  include ActiveJob::TestHelper

  let(:user){ create(:user) }
  let!(:group) { create(:group) }
  let(:channel) { build(:channel) }

  let!(:member1) { create(:member, full_name: "test1", phone: "85510000000", email: "foo@example.com") }
  let!(:member2) { create(:member, full_name: "test2", phone: "85520000000", email: "bar@example.com") }

  let!(:membership1) { create(:membership, member: member1, group: group) }
  let!(:membership2) {create(:membership, member: member2, group: group)}

  let(:group_message){ build(:group_message, user: user, receiver_groups: [group.id], message: "I am sending the group message for testing", email_alert: true, sms_alert: true)}
  let(:group_message_result){ GroupMessageResult.new(group_message)}

  describe "#run" do
    before(:each) do
      allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('85510000000').and_return(channel)
      allow_any_instance_of(Channels::ChannelSuggested).to receive(:suggested).with('85520000000').and_return(channel)
    end

    it "enqueue the alert mailer" do
      expect(AlertMailer).to receive(:delay_for).with(1.minute).and_return(AlertMailer)
      expect(AlertMailer).to receive(:notify_group_message).with(group_message, ["foo@example.com", "bar@example.com"]).once

      group_message_result.run
    end

    it "enqueue the alert sms" do
      group_message_result.run

      expect(enqueued_jobs.size).to eq(1)
    end
  end
end
