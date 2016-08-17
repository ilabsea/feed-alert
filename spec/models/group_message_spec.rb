require 'rails_helper'

RSpec.describe GroupMessage, type: :model do
  let(:user){ create(:user) }
  let!(:group) { create(:group) }

  let!(:member1) { create(:member, full_name: "test1", phone: "85510000000", email: "foo@example.com") }
  let!(:member2) { create(:member, full_name: "test2", phone: "85520000000", email: "bar@example.com") }

  let!(:membership1) { create(:membership, member: member1, group: group) }
  let!(:membership2) {create(:membership, member: member2, group: group)}

  let(:group_message){ build(:group_message, user: user, receiver_groups: [group.id], message: "I am sending the group message for testing", alert_type: ["email", "phone"])}

  describe 'validations' do
    it { should validate_presence_of(:receiver_groups).with_message("Receiver's group cannot be blank") }
    it { should validate_presence_of(:alert_type).with_message("Email or SMS is required") }
    it { should validate_presence_of(:message).with_message("Message cannot be blank") }
  end

  describe '#alert_type?' do
    it {
      expect(group_message.has_alert?('email')).to be true
      expect(group_message.has_alert?('phone')).to be true
      expect(group_message.has_alert?('sms')).to be false
    }
  end

  describe '#recipients_by' do
    context "email" do
      it { expect(group_message.recipients_by("email")).to contain_exactly("foo@example.com", "bar@example.com") }
    end
    context "phone" do
      it { expect(group_message.recipients_by("phone")).to contain_exactly("85510000000", "85520000000") }
    end
  end
end
