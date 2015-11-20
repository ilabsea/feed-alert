class ChannelAccess < ActiveRecord::Base
  belongs_to :project
  belongs_to :channel

  validates :channel_id, presence: true
  validates :project_id, presence: true

end
