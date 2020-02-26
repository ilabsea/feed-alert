require 'rails_helper'

RSpec.describe AlertDigest, type: :model do
  ActiveJob::Base.queue_adapter = :test

  let(:project) { create(:project) }
  let!(:alert) { create(:alert, project: project) }
  let!(:keyword) { create(:keyword, name: 'instedd') }
  let!(:alert_keyword) { create(:alert_keyword, alert_id: alert.id, keyword_id: keyword.id) }
  let(:email) { 'foo@example.com' }

  let!(:alert_digest) { AlertDigest.new(email, [alert.id]) }

  describe "#run" do
    before(:each) do
      @alert_snapshot = {
        alert_id: alert.id,
        snapshots: [
          {
            "_index"=>"feed_entries", "_type"=>"feed_entry", "_id"=>"foo", "_score"=>0.0922051,
            "_source"=>{
              "title"=>"Foo Bar", "keywords"=>["foo", "bar"],
              "url"=>"http://www.cnn.com/2016/07/13/politics/boris-johnson-us-politicians/index.html",
              "alert_id"=>alert.id
            }
          }
        ]
      }

      allow(alert_digest).to receive(:get_alert_snapshot).and_return(@alert_snapshot)
      allow_any_instance_of(FeedEntrySearchResultPresenter).to receive(:alerts).and_return([alert])

      # text = "What would be really nice is #{keyword.name} to have a block-style expectation matcher"
      # feed_entry = FeedEntry.create(title: FFaker::Name.name, url: alert.url, summary: text, content: text, alert_id: alert.id)
      # feed_entry.save
    end

    it "send digest mail" do
      expect(::AlertMailer).to receive(:notify_matched).with(email, [@alert_snapshot])
      alert_digest.run
    end
  end

  describe "#alert" do
    before(:each) do
      allow(alert).to receive(:has_match?).and_return(true)
    end

    # context "email" do
    #   before(:each) do
    #     allow(alert_digest).to receive(:delay_time).and_return(1)
    #     allow(alert_digest).to receive(:alert_highlight).with(alert.id).and_return({})
    #   end

    #   it "Add email for every user to queue" do
    #     expect(AlertMailer).to receive(:delay_for).with(1.minute).and_return(AlertMailer)
    #     expect(AlertMailer).to receive(:notify_matched).with({}, alert.id, group.name, ["foo@example.com", "bar@example.com"]).once

    #     alert_digest.alert_email(alert)
    #   end
    # end

  end

end
