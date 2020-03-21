require 'rails_helper'

RSpec.describe KeywordSet, type: :model do
  it { should have_many(:alert_keyword_sets).dependent(:destroy) }
  it { should have_many(:alerts).through(:alert_keyword_sets) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }

  describe "validation duplicate name" do
    let!(:keyword_set) { create(:keyword_set) }

    it "should check for duplication name" do
      keyword_set_1 = KeywordSet.new(name: keyword_set.name, keyword: "foo,bar", user_id: 1)

      expect(keyword_set_1.valid?).to eq(false)
      expect(keyword_set_1.errors.messages).to eq(name: ["has already been taken"])
    end
  end

  describe "#excludes" do
    let!(:keyword_set) { create(:keyword_set) }
    let!(:keyword_set_1) { create(:keyword_set) }

    it "should excluded record with specified ids" do
      results = KeywordSet.excludes([keyword_set.id])
      expect(results).to eq([keyword_set_1])
    end
  end

  describe "#from_query" do
    let!(:keyword_set) { create(:keyword_set, name: "outbreak") }
    let!(:keyword_set_1) { create(:keyword_set, name: "pandemic") }

    it "should return record with match query" do
      results = KeywordSet.from_query("out")
      expect(results).to eq([keyword_set])
    end
  end
end
