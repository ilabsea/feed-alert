class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups
  serialize :alert_type

  validates_presence_of :receiver_groups, message: "Receiver's group cannot be blank"
  validates_presence_of :alert_type, message: "Email or SMS is required"
  validates_presence_of :message, message: 'Message cannot be blank'

  SMS = "phone"
  EMAIL = "email"

  ALERT_TYPE = {GroupMessage::EMAIL => "Email", GroupMessage::SMS => "SMS"}

  def send_ao!
    if has_alert?(GroupMessage::SMS)
      active_channels = Channels::Accessible::UserChannelAccessible.new(self.user).list
      if active_channels.empty?
        errors.add(:base, "No sms channel found, please make sure you have the accessible channel before sending the sms")
        raise Errors::UnknownChannelExpcetion.new(self)
      end
    end

    self.save!
    GroupMessageResult.new(self).run
  end

  def has_alert?(type)
    alert_type.include?(type)
  end

  def recipients_by(type)
    has_alert?(type) ? recipients(type) : []
  end

  def self.migrate_alert_type
    GroupMessage.transaction do
      GroupMessage.find_each(batch_size: 100) do |group_message|
        alert_type = []
        alert_type << "email" if group_message.email_alert
        alert_type << "phone" if group_message.sms_alert
        group_message.update_attributes(alert_type: alert_type)
      end
    end
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
