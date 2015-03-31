class Alert < ActiveRecord::Base
  include AlertMatchCriteria

  has_many :alert_groups, dependent: :destroy
  has_many :groups, through: :alert_groups

  has_many :alert_keywords, dependent: :destroy
  has_many :keywords, through: :alert_keywords

  has_many :alert_places, dependent: :destroy
  has_many :places, through: :alert_places

  has_many :feeds
  has_many :feed_entries

  accepts_nested_attributes_for :alert_places, allow_destroy: true

  INTERVAL_UNIT_HOUR = "Hour"
  INTERVAL_UNIT_DAY  = "Day"

  INTERVAL_UNITS = [INTERVAL_UNIT_HOUR, INTERVAL_UNIT_DAY]

  validates :name, presence: true
  validates :url, presence: true
  validates :interval, presence: true, numericality: {greater_than: 0}
  validates :email_template, presence: true
  validates :sms_template, presence: true

  def matched_in_between(date_range)
    self.feed_entries.matched.between(date_range)
  end

  def self.evaluate date_range
    alerts = Alert.matched(date_range)

    alerts.each do |alert|
      alert.groups.each do |group|
        emails_to = group.members.map(:email)
        if emails_to.length > 0 && alert.feed_entries.length > 0
          AlertMailer.notify_matched(alert, group, emails_to, date_range)
        end
      end
    end
  end
end
