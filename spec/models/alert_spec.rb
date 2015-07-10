# == Schema Information
#
# Table name: alerts
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  url                  :string(255)
#  interval             :float(24)
#  interval_unit        :string(255)
#  email_template       :text(65535)
#  sms_template         :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  alert_places_count   :integer          default(0)
#  alert_groups_count   :integer          default(0)
#  alert_keywords_count :integer          default(0)
#  from_time            :string(255)
#  to_time              :string(255)
#  project_id           :integer
#  channel_id           :integer
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#is_time_appropiate?' do
    let(:alert) {create(:alert, from_time: '08:00', to_time: '8:10')}
    context "call time is between from_time and to_time" do
      it 'return true' do
        call_time = Time.new(2015, 10,10, 8, 10, 10)
        result = alert.is_time_appropiate?(call_time)
        expect(result).to eq true
      end
    end

    context 'call time is out of range' do
      it 'return false' do
        call_time = Time.new(2015, 10,10, 8, 20, 10)
        result = alert.is_time_appropiate?(call_time)
        expect(result).to eq false
      end
    end
  end

end
