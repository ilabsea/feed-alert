class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups
  
  validates :receiver_groups, presence: true

  def send_ao
    active_channels = []
    if self.sms_alert
      active_channels = ChannelNuntium.active_channels(self.user.accessible_channels)
      if active_channels.empty?
        self.errors.add(:base, "No sms channel found, please make sure you have the accessible channel before sending the sms")
        return false
      end
    end
    if self.save
      GroupMessageResult.new(self, active_channels).run
      return true
    end
    return false

  end
  
  def has_active_channel?
    ChannelNuntium.active_channels(self.user.accessible_channels)
  end

end
