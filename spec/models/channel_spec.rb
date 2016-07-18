require 'rails_helper'

RSpec.describe Channel, type: :model do
  let!(:project) {create(:project)}

  let(:smart) {create(:national_channel, name: 'smart', is_enable: true)}
  let(:camgsm) {create(:national_channel, name: 'camgsm', is_enable: true)}
  let(:basic) {create(:basic_channel, name: 'basic')}
  let(:advance) {create(:advance_channel, name: 'advance')}
  let(:channels) {[smart, camgsm,  basic, advance]}

  let!(:channel_smart) {create(:channel_access, project: project, channel: smart, is_active: true)}
  let!(:channel_camgsm) {create(:channel_access, project: project, channel: camgsm, is_active: true)}

	describe '.national_gateway' do
      it { expect(Channel.national_gateway).to eq([smart, camgsm])}
	    it { expect(Channel.national_gateway).to include(smart, camgsm)}
	    it { expect(Channel.national_gateway).not_to include(basic, advance)}
	end

end
