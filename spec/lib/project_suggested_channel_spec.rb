require 'rails_helper'

describe ProjectSuggestedChannel, :type => :model do

  describe 'suggest_by_phone_number' do

    let(:user){create(:user)}
    let(:admin_user){create(:admin_user)}
    let(:camgsm){create(:channel, name: 'camgsm', is_enable: true, setup_flow: 'National', user_id: admin_user.id)}
    let(:smart){create(:channel, name: 'smart', is_enable: true, setup_flow: 'National', user_id: admin_user.id)}
    let(:deactive_channel){create(:channel, user_id: user.id)}
    let(:channel){create(:channel, user_id: user.id, is_enable: true)}
    let(:project){create(:project, user_id: user.id)}
    context 'with national channels accessing' do
      context 'when the tel carrier matches the national channels ' do
        before{
          smart_access = create(:channel_access, project_id: project.id, channel_id: smart.id, is_active: true)
          camgsm_access = create(:channel_access, project_id: project.id, channel_id: camgsm.id, is_active: true)         
          channel_access = create(:channel_access, project_id: project.id, channel_id: channel.id, is_active: true)    
        }        
        it 'return national channel match with tel carrier' do
          project_channels = ProjectSuggestedChannel.new(project)
          expect(project_channels.by_phone_number "85510999999").to eq smart
          expect(project_channels.by_phone_number "092999999").to eq camgsm
        end
      end

      context 'when the tel carrier does not match the national channels ' do
        before{
          smart_access = create(:channel_access, project_id: project.id, channel_id: smart.id, is_active: true)        
          channel_access = create(:channel_access, project_id: project.id, channel_id: channel.id, is_active: true)    
        }        
        it 'return the first enabled channels' do
          project_channels = ProjectSuggestedChannel.new(project)
          expect(project_channels.by_phone_number "85512999999").to eq smart
          expect(project_channels.by_phone_number "+85598999999").to eq smart
        end      
      end
    end

    context 'with no national channels accessing' do
      before{
        channel_access = create(:channel_access, project_id: project.id, channel_id: channel.id, is_active: true)
      }
      it 'return the first enabled channels' do
        project_channels = ProjectSuggestedChannel.new(project)
        expect(project_channels.by_phone_number "85510999999").to eq channel
      end      
    end

    context 'with no channels accessing' do
      it 'return nil' do
        project_channels = ProjectSuggestedChannel.new(project)
        expect(project_channels.by_phone_number "85510999999").to be_nil
      end
    end
  end

end