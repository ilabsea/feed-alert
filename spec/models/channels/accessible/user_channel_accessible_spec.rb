require 'rails_helper'

describe Channels::Accessible::UserChannelAccessible, :type => :model do
  describe '#list' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user)}
    let(:smart) { create(:channel, is_enable: true)}

    let(:channel_accessible) { Channels::Accessible::UserChannelAccessible.new(user) }

    context 'with the channels' do
      let!(:channel) { create(:channel, user: user, is_enable: true)}

      it { expect(channel_accessible.list).to eq [channel] }
    end

    context 'with the shared channels' do
      let!(:channel_permissions) { create(:channel_permission, channel: smart, user: user, role: User::PERMISSION_ROLE_ADMIN) }

      it { expect(channel_accessible.list).to eq [smart] }
    end

    context 'with the channel access of the project' do
      context 'with the projects' do
        let!(:channel_access) { create(:channel_access, project: project, channel: smart, is_active: true)}

        it { expect(channel_accessible.list).to eq [smart] }
      end

      context 'with the shared project' do
        let!(:share_project) { create(:project) }
        let!(:channel_access) { create(:channel_access, project: share_project, channel: smart, is_active: true)}
        let!(:project_permission) { create(:project_permission, project: share_project, user: user, role: User::PERMISSION_ROLE_ADMIN) }

        it { expect(channel_accessible.list).to eq [smart] }
      end
    end

  end
end
