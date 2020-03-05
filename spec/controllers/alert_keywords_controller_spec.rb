require "rails_helper"

RSpec.describe AlertKeywordsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  before(:each) do
    subject.stub(current_user: user, authenticate_user!: true)
  end

  describe "POST #create" do
    let!(:alert) { create(:alert) }
    let!(:keyword_set) { create(:keyword_set, user: user) }

    context "successful create" do
      it "should create record" do
        post :create, keyword: keyword_set.name, alert_id: alert.id

        expect(AlertKeywordSet.count).to eq(1)
        expect(subject).to render_template(partial: nil, layout: [])
      end
    end

    context "fail to create" do
      let!(:alert_keyword_set) { create(:alert_keyword_set, alert: alert, keyword_set: keyword_set) }

      it "should return error message when keyword_set is not provided" do
        post :create, keyword: keyword_set.name, alert_id: alert.id

        expect(AlertKeywordSet.count).to eq(1)
        expect(response).to have_http_status(422)
        expect(response.body).to eq("Alert has already been taken")
      end

      it "should return error message when duplicate" do
        post :create, keyword: keyword_set.name, alert_id: alert.id

        expect(AlertKeywordSet.count).to eq(1)
        expect(response).to have_http_status(422)
        expect(response.body).to eq("Alert has already been taken")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:alert) { create(:alert) }
    let!(:keyword_set) { create(:keyword_set, user: user) }
    let!(:alert_keyword_set) { create(:alert_keyword_set, alert: alert, keyword_set: keyword_set) }

    it "delete record" do
      delete :destroy, alert_id: alert.id, id: alert_keyword_set.id
      expect(AlertKeywordSet.count).to eq(0)
      expect(response).to have_http_status(200)
    end
  end
end
