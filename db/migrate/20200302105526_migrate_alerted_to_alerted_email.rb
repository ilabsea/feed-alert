class MigrateAlertedToAlertedEmail < ActiveRecord::Migration
  def up
    begin
      feed_entries = FeedEntry.where(alerted: true)
      ids = feed_entries.entries.map &:id
      FeedEntry.mark_as_email_alerted(ids)
    rescue
      Rails.logger.info "no elasticsearch index. skip migrate email alerted"
    end
  end
end
