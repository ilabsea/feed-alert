class AddProjectIdToAlerts < ActiveRecord::Migration
  def change
    add_reference :alerts, :project, index: true
    add_foreign_key :alerts, :projects
  end
end
