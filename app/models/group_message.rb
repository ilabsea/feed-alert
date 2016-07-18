class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups

  validates :receiver_groups, presence: true

  def send_ao!
    if sms_alert
      active_channels = Channels::Accessible::UserChannelAccessible.new(self.user).list
      if active_channels.empty?
        errors.add(:base, "No sms channel found, please make sure you have the accessible channel before sending the sms")
        save!
        raise Errors::UnknownChannelExpcetion.new(self)
      end
    end

    self.save!
    GroupMessageResult.new(self).run
  end

end
