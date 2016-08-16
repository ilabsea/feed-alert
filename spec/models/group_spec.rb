require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:group) { create(:group) }

  let!(:member1) { create(:member, full_name: "test1", phone: "85510000000", email: "foo@example.com") }
  let!(:member2) { create(:member, full_name: "test2", phone: "85520000000", email: "bar@example.com") }

  let!(:membership1) { create(:membership, member: member1, group: group) }
  let!(:membership2) {create(:membership, member: member2, group: group)}

  describe "#recipients" do
    context "email" do
      it { expect(group.recipients("email")).to contain_exactly("foo@example.com", "bar@example.com") }
    end

    context "phone" do
      it { expect(group.recipients("phone")).to contain_exactly("85510000000", "85520000000") }
    end

  end

end
