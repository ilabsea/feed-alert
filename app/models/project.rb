# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Project < ActiveRecord::Base
  belongs_to :user

  has_many :project_permissions, dependent: :destroy
  has_many :shared_users, class_name: 'User', through: :project_permissions

  has_many :group_permissions, dependent: :destroy

  validates :name, presence: true

  has_many :alerts, dependent: :destroy
  has_many :channel_accesses, dependent: :destroy
  has_many :channels, through: :channel_accesses

  strip_attributes only: [:name]

  def access_role=(role)
    @access_role = role
    self
  end

  def admin_access_role?
    @access_role != User::PERMISSION_ROLE_NORMAL
  end

  def accessible_channels
    channel_ids = self.channels.map(&:id) + self.user.my_channels.pluck(:id) + self.user.channel_permissions.pluck(:channel_id)
    Channel.where(id: channel_ids, is_enable: true)
  end

  def accessible_channel(channel_id)
    channels = self.accessible_channels
    channel = channels.where(id: channel_id)
    return ObjectWithRole.new(channel) if channel

    permission = self.user.channel_permissions.find_by(channel_id: channel_id)
    return ObjectWithRole.new(permission.channel, permission.role) if permission
    raise ActiveRecord::RecordNotFound

  end

  def is_active_channel? channel
    channel_access = self.channel_accesses.select { |c| c.channel_id ==  channel.id}.first
    channel_access ? channel_access.is_active : false
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "name LIKE ?", like ])
  end

  def self.query_by_user(user_id)
    if user_id == ''
      all
    else
      where(user_id: user_id)
    end
  end

  def self.query_by_user_email(email)
    if email && email != ""
      return self.joins(:user).where('users.email' => email).group('users.email', 'name')
    end
    self.joins(:user).group('users.email', 'name')
  end

  def reset_national_gateway_channel_access channel_ids
    national_gateway_ids = Channel.national_gateway.pluck(:id)
    channel_accesses = self.channel_accesses.where(channel_id: national_gateway_ids)
    channel_accesses.where.not(channel_id: channel_ids).destroy_all
  end

  def build_national_gateway_channel_access channel_ids
    self.reset_national_gateway_channel_access channel_ids
    if channel_ids
      ChannelAccess.transaction do
        channel_ids.each do |channel_id|
          is_exist_channel_access = self.channel_accesses.find_by_channel_id(channel_id)
          if !is_exist_channel_access
            channel_access = self.channel_accesses.build(channel_id: channel_id)
            channel_access.save
          end
        end
      end
    end
  end

  def enabled_channels
    self.channels.where('channel_accesses.is_active = ? && channels.is_enable = ?', true, true)
  end

  def time_appropiate? sms_time
    if has_sms_alert_started_at? && has_sms_alert_ended_at?
      working_minutes = sms_time.hour * 60 + sms_time.min
      return in_minutes(self.sms_alert_started_at) <= working_minutes && working_minutes <= in_minutes(self.sms_alert_ended_at)
    end
    return false
  end

  def in_minutes field
    field.split(":")[0].to_i * 60 + field.split(":")[1].to_i
  end

  def is_accessible_to_national_gateway?
    national_channel_ids = Channel.national_gateway.pluck(:id)
    project_national_channels = self.channels.where(id: national_channel_ids)
    if project_national_channels.length > 0
      true
    else
      false
    end
  end

  def has_sms_alert_started_at?
    sms_alert_started_at
  end

  def has_sms_alert_ended_at?
    sms_alert_ended_at
  end

end
