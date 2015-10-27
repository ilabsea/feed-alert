require 'rails_helper'

RSpec.describe Channel, type: :model do
  let(:smart) {create(:national_channel, name: 'smart')}
  let(:camgsm) {create(:national_channel, name: 'camgsm')}
  let(:basic) {create(:basic_channel, name: 'basic')}
  let(:advance) {create(:advance_channel, name: 'advance')}
  let(:channels) {[smart, camgsm,  basic, advance]}
  
	describe '.national_gateway' do
      it { expect(Channel.national_gateway).to eq([smart, camgsm])}
	    it { expect(Channel.national_gateway).to include(smart, camgsm)}
	    it { expect(Channel.national_gateway).not_to include(basic, advance)}
	end

end