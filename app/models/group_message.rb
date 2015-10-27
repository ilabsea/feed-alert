class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups
  
  validates :receiver_groups, presence: true

  def send_ao
    if self.save
      # active_channels = Channel.active_channels(self.user.accessible_channels)
      active_channels = self.user.accessible_channels
      GroupMessageResult.new(self, active_channels).run
      return true
    else
      return false
    end   
  end
  
end
