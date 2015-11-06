require 'rails_helper'

describe GroupMessageResult, :type => :model do

  describe '.parse' do

    let(:camgsm){create(:national_channel, name: 'camgsm')}
    let(:smart){create(:national_channel, name: 'smart')}
    let(:basic_channel){create(:basic_channel, name: 'basic_channel')}
    let(:advance_channel){create(:advance_channel, name: 'advance_channel')}

    let(:group_smart){create(:group)}
    let(:group_camgsm){create(:group)}
    let(:group_metfone){create(:group)}

    let(:group_message){create(:group_message, receiver_groups: [group_smart.id, group_camgsm.id, group_metfone.id], message: "I am testing the group message from feed-alert")}
    let(:group_message_result){GroupMessageResult.new(group_message, [basic_channel, advance_channel, camgsm, smart])}    
    
    before{
      3.times do |i|
        member = create(:member, full_name: "member_#{i}", phone: "85501012345#{i}", email: "test_#{i}@example.com")
        create(:membership, member_id: member.id, group_id: group_smart.id)
      end

      2.times do |i|
        member = create(:member, full_name: "member_#{i+3}", phone: "+8551212345#{i+3}", email: "test_#{i+3}@example.com")
        create(:membership, member_id: member.id, group_id: group_camgsm.id)
      end

      2.times do |i|
        member = create(:member, full_name: "member_#{i+5}", phone: "8559712345#{i+5}", email: "test_#{i+5}@example.com")
        create(:membership, member_id: member.id, group_id: group_metfone.id)
      end      
    }
 
    it{
      messages = [{:from=>"FeedAlert", :to=>"sms://855010123450", :body=>"I am testing the group message from feed-alert", :suggested_channel=>"smart"},
                  {:from=>"FeedAlert", :to=>"sms://855010123451", :body=>"I am testing the group message from feed-alert", :suggested_channel=>"smart"},
                  {:from=>"FeedAlert", :to=>"sms://855010123452", :body=>"I am testing the group message from feed-alert", :suggested_channel=>"smart"},
                  {:from=>"FeedAlert", :to=>"sms://+85512123453", :body=>"I am testing the group message from feed-alert", :suggested_channel=>"camgsm"},
                  {:from=>"FeedAlert", :to=>"sms://+85512123454", :body=>"I am testing the group message from feed-alert", :suggested_channel=>"camgsm"},
                  {:from=>"FeedAlert", :to=>"sms://85597123455", :body=>"I am testing the group message from feed-alert", :suggested_channel=>"basic_channel"},
                  {:from=>"FeedAlert", :to=>"sms://85597123456", :body=>"I am testing the group message from feed-alert", :suggested_channel=>"basic_channel"}]
      expect(group_message_result.parse).to eq messages
    }
  end
end