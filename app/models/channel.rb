class Channel < ActiveRecord::Base
  include NuntiumConnector

  belongs_to :user, counter_cache: true

  has_many :channel_permissions, dependent: :destroy
  has_many :shared_users, class_name: 'User', through: :channel_permissions, source: :user, dependent: :destroy

  has_many :alerts, dependent: :nullify

  SETUP_FLOW_BASIC    = 'Basic'
  SETUP_FLOW_ADVANCED = 'Advanced'
  SETUP_FLOW_GLOBAL = 'National'

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 30}
  validates :name, uniqueness: { scope: :user_id}
  validates :password, presence: true, length: {minimum: 4, maximum: 6}, if: ->(u) { u.advanced_setup? }

  validates :ticket_code, :presence => {:on => :create},  if: ->(u) { u.basic_setup? }


  attr_accessor :ticket_code

  def self.enabled
    where(is_enable: true)
  end

  def basic_setup?
    self.setup_flow == Channel::SETUP_FLOW_BASIC
  end

  def advanced_setup?
    self.setup_flow == Channel::SETUP_FLOW_ADVANCED
  end

  def global_setup?
    self.setup_flow == Channel::SETUP_FLOW_GLOBAL
  end

  def update_state(state)
    self.is_enable = state
    if self.save && (state == true || state == 'true' || state == "1" || state == 1)
      Channel.where(['user_id = ? AND id != ?', self.user_id, self.id ])
             .update_all({is_enable: false })
    end
  end
end
