class Channel < ActiveRecord::Base
  include NuntiumConnector

  belongs_to :user, counter_cache: true

  SETUP_FLOW_BASIC    = 'Basic'
  SETUP_FLOW_ADVANCED = 'Advanced'
  SETUP_FLOW_GLOBAL = 'National'

  validates :name, presence: true, length: { minimum: 3, maximum: 30}
  validates :name, uniqueness: { scope: :user_id}
  validates :password, :presence => true, :length => {:minimum => 4, :maximum => 6}, if: ->(u) { u.advanced_setup? }
  validates :ticket_code, :presence => {:on => :create}, if: ->(u) { u.basic_setup? }

  attr_accessor :ticket_code

  def random_password
    self.password = SecureRandom.base64(6) if self.password.blank?
  end

  def self.enabled
    where(is_enable: true)
  end

  def gateway_url
    nuntium.endpoint
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
end
