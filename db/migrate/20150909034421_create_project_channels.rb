class CreateProjectChannels < ActiveRecord::Migration
  def change
    create_table :project_channels do |t|
      t.integer :project_id, belongs_to: :projects
      t.integer :channel_id, belongs_to: :channels
      t.timestamps null: false
    end
  end
end
