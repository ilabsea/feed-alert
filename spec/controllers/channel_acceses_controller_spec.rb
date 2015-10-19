require 'rails_helper'

RSpec.describe ChannelAccessesController do

  describe 'GET #new' do
    context 'as an admin role' do
      let!(:user) { FactoryGirl.create(:admin_user) }
      before {
       subject.stub(current_user: user, authenticate_user!: true)
       get :new
      }
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }
    end

    context 'as a normal user role' do
      let!(:user) { FactoryGirl.create(:user) }
      before {
       subject.stub(current_user: user, authenticate_user!: true)
       get :new
      }
      it { is_expected.to redirect_to root_url }
    end
  end

  describe 'POST #create' do
    let!(:user) { FactoryGirl.create(:admin_user) }
    let!(:project) { FactoryGirl.create(:project) }
    before {
     subject.stub(current_user: user, authenticate_user!: true)
    }
    context "with valid params" do
      before(:each) do
        post :create, {project: {id: project.id, is_enabled_national_gateway: "1"} }
      end

      it "update is_enabled_national_gateway in @project" do
        expect(Project.find(project.id).is_enabled_national_gateway).to equal(true)
      end

      it { is_expected.to redirect_to new_channel_accesses_path }
    end

  end

end