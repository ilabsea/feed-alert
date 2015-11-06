require 'rails_helper'

describe Tel, :type => :model do
  context 'without prefix' do
    it { expect(Tel.new('012999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('85512999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('+85512999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('855012999999').without_prefix).to eq('12999999') }
    it { expect(Tel.new('+855012999999').without_prefix).to eq('12999999') }

    it { expect(Tel.new('12999999').without_prefix).to eq('12999999') }
  end

  context 'carrier' do
    it { expect(Tel.new('012999999').carrier).to eq('camgsm') }
    it { expect(Tel.new('85517999999').carrier).to eq('camgsm') }
    it { expect(Tel.new('+85592999999').carrier).to eq('camgsm') }
    it { expect(Tel.new('855011999999').carrier).to eq('camgsm') }
    it { expect(Tel.new('+855061999999').carrier).to eq('camgsm') }
    it { expect(Tel.new('76999999').carrier).to eq('camgsm') }

    it { expect(Tel.new('010999999').carrier).to eq('smart') }   
    it { expect(Tel.new('85596999999').carrier).to eq('smart') }   
    it { expect(Tel.new('+85593999999').carrier).to eq('smart') }   
    it { expect(Tel.new('855098999999').carrier).to eq('smart') }   
  end

end