class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups

  validates_presence_of :receiver_groups, :message => "Receiver's group cannot be blank"

  def send_ao!
    if sms_alert
      active_channels = Channels::Accessible::UserChannelAccessible.new(self.user).list
      if active_channels.empty?
        errors.add(:base, "No sms channel found, please make sure you have the accessible channel before sending the sms")
        raise Errors::UnknownChannelExpcetion.new(self)
      end
    end

    self.save!
    GroupMessageResult.new(self).run
  end

end
