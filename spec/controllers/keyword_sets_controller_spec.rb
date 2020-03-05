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
        post :create, keyword_set: { name: "outbreak", keyword: 'covid-19,H1N1,H5N5' }
        expect(KeywordSet.count).to eq(1)
        expect(subject).to redirect_to(keyword_sets_path)
      end
    end

    context "error created record" do
      let!(:keyword_set) { create(:keyword_set, name: "outbreak", user_id: user.id) }

      it "show error message" do
        post :create, keyword_set: { name: "outbreak", keyword: 'covid-19,H1N1,H5N5' }
        expect(KeywordSet.count).to eq(1)
        expect(subject).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let!(:keyword_set) { create(:keyword_set, name: "outbreak", user_id: user.id) }

    it "returns http success" do
      get :edit, id: keyword_set.id
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    context "successfully updated record" do
      let!(:keyword_set) { create(:keyword_set, user_id: user.id) }

      it "create keyword set record" do
        put :update, id: keyword_set.id, keyword_set: { id: keyword_set.id, name: "new outbreak", keyword: 'covid-19,H1N1,H5N5' }
        expect(subject).to redirect_to(keyword_sets_path)
      end
    end

    context "error created record" do
      let!(:keyword_set) { create(:keyword_set, name: "outbreak", user_id: user.id) }
      let!(:keyword_set_1) { create(:keyword_set, name: "pandemic", user_id: user.id) }

      it "show error message" do
        put :update, id: keyword_set.id, keyword_set: { id: keyword_set.id, name: keyword_set_1.name }
        expect(subject).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:keyword_set) { create(:keyword_set, user_id: user.id) }

    it "delete record and redirect to index page" do
      delete :destroy, id: keyword_set.id
      expect(KeywordSet.count).to eq(0)
      expect(subject).to redirect_to(keyword_sets_path)
    end
  end
end
