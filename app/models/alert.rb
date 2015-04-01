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
      emails_to = []
      smses_to  = []

      group.members.each do |member|
        emails_to << member.email if member.email_alert
        smses_to  << member.phone if member.sms_alert
      end

      matched_entries = alert.feed_entries

      if emails_to.length > 0 && matched_entries.length > 0
        AlertMailer.notify_matched(alert, group, date_range).deliver_now
      end

      if smses_to.length > 0 && matched_entries.length > 0
        smses_to.each do |sms|
          to = "sms://#{sms}"
          options = { from: ENV['APP_NAME'],
                      to: 'sms://0975553553',
                      body: "#{alert.name} has #{pluralize(matched_entries.length, 'feed entry')}" }
          SmsAlertJob.set(wait: 10.seconds).perform_later(options)
        end
      end
    end

    end
  end

end
