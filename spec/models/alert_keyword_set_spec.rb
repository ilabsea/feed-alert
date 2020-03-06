require 'rails_helper'

RSpec.describe AlertKeywordSet, type: :model do
  it { should belong_to(:alert).touch(:true) }
  it { should belong_to(:keyword_set) }

  it { should validate_presence_of(:alert_id) }
  it { should validate_presence_of(:keyword_set_id) }

  describe "validate duplicate record" do
    let!(:alert) { create(:alert) }
    let!(:keyword_set) { create(:keyword_set) }
    let!(:alert_keyword_set) { create(:alert_keyword_set, alert_id: alert.id, keyword_set_id: keyword_set.id) }

    it "should check for duplicate record" do
      alert_keyword_set_1 = AlertKeywordSet.new(alert_id: alert.id, keyword_set_id: keyword_set.id)
      expect(alert_keyword_set_1.valid?).to eq(false)
      expect(alert_keyword_set_1.errors.messages).to eq(alert_id: ["has already been taken"])
    end
  end
end