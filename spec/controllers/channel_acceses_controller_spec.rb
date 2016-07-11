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

  describe 'POST #national_gateway' do
    let!(:user) { FactoryGirl.create(:admin_user) }
    let!(:project) { FactoryGirl.create(:project) }
    let!(:channel) { FactoryGirl.create(:national_channel) }
    before {
     subject.stub(current_user: user, authenticate_user!: true)
    }
    context "with channel_id" do
      before(:each) do
        post :national_gateway, {channel_access: {project_id: project.id, channel_id: [channel.id] }}
      end

      it "create the channel_access" do
        expect(ChannelAccess.find_by(project_id: project.id)).not_to be_nil
      end

      it { is_expected.to redirect_to channel_accesses_path }
    end

    context "without channel_id" do
      before(:each) do
        post :national_gateway, {channel_access: {project_id: project.id, channel_id: [] }}
      end

      it "destroy the channel accesses that related to the project_id" do
        expect(ChannelAccess.find_by(project_id: project.id)).to be_nil
      end

      it { is_expected.to redirect_to channel_accesses_path }
    end
  end

end
