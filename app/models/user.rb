# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  email                :string(255)
#  phone                :string(255)
#  password_digest      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  role                 :string(255)
#  email_alert          :boolean          default(FALSE)
#  sms_alert            :boolean          default(FALSE)
#  full_name            :string(255)
#  auth_token           :string(255)
#  confirmed_token      :string(255)
#  confirmed_at         :datetime
#  reset_password_token :string(255)
#  reset_password_at    :datetime
#  channels_count       :integer          default(0)
#

class User < ActiveRecord::Base
  has_secure_password(validations: false)

  has_many :my_projects, class_name: "Project"
  has_many :my_channels, class_name: "Channel"

  has_many :project_permissions
  has_many :shared_projects, class_name: "Project", through: :project_permissions, source: :project

  has_many :channel_permissions
  has_many :shared_channels, class_name: "Channel", through: :channel_permissions, source: :channel

  has_many :groups
  has_many :members

  has_many :group_permissions
  has_many :shared_groups, class_name: "Group", through: :group_permissions, source: :group

  has_many :channels

  # password must be present within 6..72
  validates :password, presence: true, on: :create
  validates :password, length: { in: 6..72}, on: :create
  validates :password, confirmation: true

  # email must be in a valid format and has unique value if it is being provided
  validates :email, email: true
  validates :email, uniqueness: true
  validates :email, email: {message: 'invalid format'}

  validates :phone, uniqueness: true, if: ->(u) { u.phone.present? }

  validates :full_name, presence: true

  ROLE_ADMIN  = 'Admin'
  ROLE_NORMAL = 'Normal'

  PERMISSION_ROLE_ADMIN   = 'Admin'
  PERMISSION_ROLE_NORMAL  = 'Read'
  PERMISSION_ROLE_NONE    = 'None'

  before_save :normalize_attrs
  before_create :generate_attrs

  attr_accessor :old_password

  def self.confirmed
    where("confirmed_at IS NOT NULL")
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "email LIKE ?", like ])
  end

  def self.excludes(ids)
    where("id not in (?)", ids)
  end


  def generate_attrs
    self.role = User::ROLE_NORMAL unless self.role.present?
    generate_token_for(:auth_token)
    generate_token_for(:confirmed_token)
  end

  def generate_token_for(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def normalize_attrs
    self.email.downcase!
  end

  def self.authenticate(email, password)
    login_email = email.blank? ? '' : email.downcase
    user = User.find_by!(email: login_email)
    user.authenticate(password)
  rescue ActiveRecord::RecordNotFound
    false
  end

  def change_password old_password, new_password, confirm
    if self.authenticate(old_password)
      self.password = new_password
      self.password_confirmation = confirm

      save
    else
      errors.add(:old_password, 'does not matched')
      false
    end
  end

  def shared
    project_permissions = ProjectPermission.select('user_id').where(project_id: self.my_projects.ids).uniq
    channel_permissions = ChannelPermission.select('user_id').where(channel_id: self.my_channels.ids).uniq
    user_ids = (project_permissions + channel_permissions).map{|item| item.user_id}.uniq
    User.where(id: user_ids)
  end

  def self.visible_roles
    [ROLE_NORMAL, ROLE_ADMIN]
  end

  def is_admin?
    role == User::ROLE_ADMIN
  end

  def accessible_project(project_id)
    project = self.my_projects.where(id: project_id).first
    return ObjectWithRole.new(project) if project

    permission = self.project_permissions.find_by(project_id: project_id)
    return ObjectWithRole.new(permission.project, permission.role) if permission
    raise ActiveRecord::RecordNotFound
  end

  def accessible_channel(channel_id)
    channel = self.my_channels.where(id: channel_id).first
    return ObjectWithRole.new(channel) if channel

    permission = self.channel_permissions.find_by(channel_id: channel_id)
    return ObjectWithRole.new(permission.channel, permission.role) if permission
    raise ActiveRecord::RecordNotFound
  end

  def accessible_group(group_id)
    group = self.groups.where(id: group_id).first
    return ObjectWithRole.new(group) if group

    permission = self.group_permissions.includes(group: [alerts: :project]).where(group_id: group_id).order('order_number DESC').first
    return ObjectWithRole.new(permission.group, permission.role) if permission
    raise ActiveRecord::RecordNotFound
  end

  def high_level_group_permissions
    group_permission_sub = self.group_permissions.select('group_id, max(order_number) as max_order_number').group('group_id')
    self.group_permissions.select("DISTINCT group_permissions.group_id, group_permissions.*").where("(group_id, order_number) in (#{group_permission_sub.to_sql}) ")
  end

  def accessible_channels
    channel_ids = self.my_channels.pluck(:id) + self.channel_permissions.pluck(:channel_id)
    Channel.where(id: channel_ids)
  end

end
