# == Schema Information
#
# Table name: alerts
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  url                  :string(255)
#  interval             :float(24)
#  interval_unit        :string(255)
#  email_template       :text(65535)
#  sms_template         :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  alert_places_count   :integer          default(0)
#  alert_groups_count   :integer          default(0)
#  alert_keywords_count :integer          default(0)
#  from_time            :string(255)
#  to_time              :string(255)
#  project_id           :integer
#  channel_id           :integer
#

class Alert < ActiveRecord::Base
  include AlertMatchCriteria

  has_many :alert_groups, dependent: :destroy
  has_many :groups, through: :alert_groups

  has_many :alert_keywords, dependent: :destroy
  has_many :keywords, through: :alert_keywords

  has_many :alert_places, dependent: :destroy
  has_many :places, through: :alert_places

  has_many :feeds, dependent: :destroy
  has_many :feed_entries

  has_many :group_permissions, dependent: :nullify

  belongs_to :project
  belongs_to :channel

  # accepts_nested_attributes_for :alert_places, allow_destroy: true

  INTERVAL_UNIT_HOUR = "Hour"
  INTERVAL_UNIT_DAY  = "Day"

  INTERVAL_UNITS = [INTERVAL_UNIT_HOUR, INTERVAL_UNIT_DAY]

  validates :name, presence: true
  validates :url, presence: true
  validates :url, url: true

  attr_accessor :total_match

  def reset_error
    self.invalid_url = 0
    self.error_message = nil
  end

  def self.valid_url
    where("invalid_url < ? ", ENV['MAX_ERROR_NUMBER'].to_i)
  end

  def has_invalid_url_error
    self.invalid_url >= ENV['MAX_ERROR_NUMBER'].to_i
  end

  def self.apply_search date_range
    Alert.includes(:keywords).find_in_batches(batch_size: 5) do |alerts|
      AlertResult.new(alerts, date_range).run
    end
  end

  def apply_search date_range
    AlertResult.new([self], date_range).run
  end

  def in_minutes field
    field.split(":")[0].to_i * 60 + field.split(":")[1].to_i
  end

  def is_time_appropiate? sms_time
    working_minutes = sms_time.hour * 60 + sms_time.min
    in_minutes(self.from_time) <= working_minutes && working_minutes <= in_minutes(self.to_time)
  end

  def translate_message
    translate_options = {
      alert_name: self.name,
      total_match: self.total_match,
      keywords: self.keywords.map(&:name).join(", ")
    }

    StringSearch.instance.set_source(self.project.sms_alert_template).translate(translate_options)
  end

  def self.search_options alerts, date_range
    options = {}
    options[:q] = alerts.map {|alert| { id: alert.id, keywords: alert.keywords.map(&:name) } }
    options[:from] = date_range.from
    options[:to] = date_range.to
    options
  end

  def self.from_member(member_id)
    group_sql = Group.select('groups.id').joins('INNER JOIN memberships ON memberships.group_id = groups.id ')
                     .where([ 'memberships.member_id=?', member_id]).to_sql

    self.includes(:project).select('distinct alerts.id, alerts.*')
                           .joins('INNER JOIN alert_groups ON alert_groups.alert_id = alerts.id')
                           .where("alert_groups.group_id in (#{group_sql})")
  end

  def mark_error message
    self.invalid_url = self.invalid_url + 1
    self.error_message = message
    self.save(validate: false)
  end

  def self.migrate_channel
    Alert.transaction do
      Alert.find_each(batch_size: 100) do |alert|
        channel = alert.channel
        project = alert.project
        channel_access = project.channel_accesses.select { |c| c.channel_id == channel.id }.first
        if !channel_access
          project.channel_accesses.new(channel_id: channel.id, is_active: true)
          project.save!
        end
      end
    end    
  end
end
