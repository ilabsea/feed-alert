class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups
  serialize :alert_type

  validates_presence_of :receiver_groups, message: "Receiver's group cannot be blank"
  validates_presence_of :alert_type, message: "Email or SMS is required"
  validates_presence_of :message, message: 'Message cannot be blank'

  ALERT_TYPE = {email: "Email", phone: "SMS"}

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

  def alert_by?(type)
    alert_type.include?(type)
  end

  def recipients_by(type)
    alert_by?(type) ? recipients(type) : []
  end

  private
  def recipients(type)
    results = []
    groups = Group.find(self.receiver_groups)
    groups.each do |group|
      results = results + group.recipients(type)
    end
    return results
  end

end
