# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:admin_user){create(:admin_user)}
  let(:user){create(:user)}
  let(:project){create(:project, user_id: user.id)}

	describe 'validations' do
    it { should validate_presence_of(:name)}
  end

  describe '#enabled_channels' do
    let(:camgsm){create(:channel, name: 'camgsm', is_enable: true, setup_flow: 'National', user_id: admin_user.id)}
    let(:smart){create(:channel, name: 'smart', is_enable: true, setup_flow: 'National', user_id: admin_user.id)}
    let(:channel){create(:channel, user_id: user.id, is_enable: true)}
    
    context 'with active channel_accesses' do
      before{
        smart_access = create(:channel_access, project_id: project.id, channel_id: smart.id, is_active: true)
        camgsm_access = create(:channel_access, project_id: project.id, channel_id: camgsm.id, is_active: true)       
        channel_access = create(:channel_access, project_id: project.id, channel_id: channel.id, is_active: true)        
      }      
      it 'return all active channels' do
        expect(project.enabled_channels).to include(smart,camgsm,channel)
      end
    end
    
    context 'with active and deactive channel_accesses' do
      before{
        smart_access = create(:channel_access, project_id: project.id, channel_id: smart.id, is_active: true)
        camgsm_access = create(:channel_access, project_id: project.id, channel_id: camgsm.id, is_active: false)       
        channel_access = create(:channel_access, project_id: project.id, channel_id: channel.id, is_active: true)        
      }      
      it 'return all active channels' do
        expect(project.enabled_channels).to include(smart,channel)      
        expect(project.enabled_channels).not_to include(camgsm)      
      end
    end

    context 'with deactive channel_accesses' do
      before{
        smart_access = create(:channel_access, project_id: project.id, channel_id: smart.id, is_active: false)
        camgsm_access = create(:channel_access, project_id: project.id, channel_id: camgsm.id, is_active: false)       
        channel_access = create(:channel_access, project_id: project.id, channel_id: channel.id, is_active: false)        
      }
      it 'return empty' do
        expect(project.enabled_channels).to be_empty
      end
    end

    context 'with no channel_accesses' do
      it 'return empty' do
        expect(project.enabled_channels).to be_empty
      end
    end
  end

end
