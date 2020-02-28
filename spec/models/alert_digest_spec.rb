require 'rails_helper'

RSpec.describe AlertDigest, type: :model do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  let(:project) { create(:project) }
  let!(:alert) { create(:alert, project: project) }
  let!(:keyword) { create(:keyword, name: 'instedd') }
  let!(:alert_keyword) { create(:alert_keyword, alert_id: alert.id, keyword_id: keyword.id) }
  let(:email) { 'foo@example.com' }

  let!(:alert_digest) { AlertDigest.new(email, [alert.id]) }
  let(:alert_snapshot) {
    {
      alert_id: alert.id,
      snapshots: [[
        {
          "_index"=>"feed_entries", "_type"=>"feed_entry", "_id"=>"foo", "_score"=>0.0922051,
          "_source"=>{
            "title"=>"Foo Bar", "keywords"=>["foo", "bar"],
            "url"=>"http://www.cnn.com/2016/07/13/politics/boris-johnson-us-politicians/index.html",
            "alert_id"=>alert.id
          }
        }
      ]]
    }
  }

  describe "#run" do
    context 'has matched feed' do

      it "send digest mail" do
        allow(alert_digest).to receive(:get_alert_snapshot).and_return(alert_snapshot)
        expect(alert_digest).to receive(:alert_email).with(email, [alert_snapshot])

        alert_digest.run
      end
    end

    context 'has no matched feed' do
      it "send digest mail" do
        expect(::AlertMailer).not_to receive(:notify_matched)
        alert_digest.run
      end
    end
  end

  describe '#alert_email' do
    let(:snapshots) { [alert_snapshot] }

    it 'should send digest email' do
      job = alert_digest.alert_email(email, snapshots)
      expect(job.arguments).to eq(['AlertMailer', 'notify_matched', 'deliver_now', email, snapshots])
    end
  end

end
