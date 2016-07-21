require 'rails_helper'

RSpec.describe SearchOption, type: :model do
  let!(:alert) { create(:alert, url: 'http://foo.bar') }
  let!(:foo) { create(:keyword, name: 'foo')}
  let!(:bar) { create(:keyword, name: 'bar')}

  let!(:alert_foo) { create(:alert_keyword, alert: alert, keyword: foo) }
  let!(:alert_bar) { create(:alert_keyword, alert: alert, keyword: bar) }

  describe '.for' do
    context 'return hash of keywords' do
      let(:result) {
        {
          q: [{id: alert.id, keywords: ['foo', 'bar']}],
          alerted: true
        }
      }

      it { expect(SearchOption.for([alert], true)).to eq result }
    end
  end
end
