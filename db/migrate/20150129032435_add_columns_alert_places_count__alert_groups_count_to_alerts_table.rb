class AddColumnsAlertPlacesCountAlertGroupsCountToAlertsTable < ActiveRecord::Migration
  def change
    add_column :alerts, :alert_places_count, :integer, default: 0
    add_column :alerts, :alert_groups_count, :integer, default: 0
    add_column :alerts, :alert_keywords_count, :integer, default: 0
  end
end
