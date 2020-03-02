class MigrateAlertedToAlertedEmail < ActiveRecord::Migration
  def change
    return unless FeedEntry.exists(index: :feed_entry)

    begin
      entries = FeedEntry.where(alerted: true)
      entries.each do |entry|
      end
    rescue
      Rails.logger.info "no elasticsearch index. skip migrate email alerted"
    end
  end
end
