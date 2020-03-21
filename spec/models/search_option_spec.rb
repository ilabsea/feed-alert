require 'rails_helper'

RSpec.describe SearchOption, type: :model do
  let!(:user) { create(:user) }
  let!(:alert) { create(:alert, url: 'http://foo.bar') }
  let!(:foo) { create(:keyword_set, name: 'foo', keyword: 'covid,h1n1', user_id: user.id)}
  let!(:bar) { create(:keyword_set, name: 'bar', keyword: 'h1n5', user_id: user.id)}

  let!(:alert_foo) { create(:alert_keyword_set, alert: alert, keyword_set: foo) }
  let!(:alert_bar) { create(:alert_keyword_set, alert: alert, keyword_set: bar) }

  describe '.for' do
    context 'return hash of keywords' do
      let(:result) {
        {
          q: [{id: alert.id, keywords: ['covid', 'h1n1', 'h1n5']}],
          alerted: true
        }
      }

      it { expect(SearchOption.for([alert], true)).to eq result }
    end
  end
end
