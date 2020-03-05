require "rails_helper"

RSpec.describe KeywordSetsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  before(:each) do
    subject.stub(current_user: user, authenticate_user!: true)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "successfully created record" do
      it "create keyword set record" do
        post :create, params: { keyword_set: { name: "outbreak", keyword: 'covid-19,H1N1,H5N5' } }
        expect(KeywordSet.count).to eq(1)
        expect(subject).to redirect_to(keyword_sets_path)
      end
    end
  end
end
