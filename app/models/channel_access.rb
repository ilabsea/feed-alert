# == Schema Information
#
# Table name: channel_accesses
#
#  id         :integer          not null, primary key
#  project_id :integer
#  channel_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_active  :boolean          default(FALSE)
#

class ChannelAccess < ActiveRecord::Base
  belongs_to :project
  belongs_to :channel

  validates :channel_id, presence: true
  validates :project_id, presence: true

end
