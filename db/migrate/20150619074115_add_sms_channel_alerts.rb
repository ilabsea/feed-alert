class AddSmsChannelAlerts < ActiveRecord::Migration
  def change
    add_reference :alerts, :channel, index: true
  end
end
