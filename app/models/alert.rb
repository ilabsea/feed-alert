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

  accepts_nested_attributes_for :alert_places, allow_destroy: true

  INTERVAL_UNIT_HOUR = "Hour"
  INTERVAL_UNIT_DAY  = "Day"

  INTERVAL_UNITS = [INTERVAL_UNIT_HOUR, INTERVAL_UNIT_DAY]

  validates :name, presence: true
  validates :url, presence: true
  validates :interval, presence: true, numericality: {greater_than: 0}

  PROCESS_TIME = 30.minutes #rake task and schedule

  attr_accessor :total_match

  def self.search_options(date_range)
    options = {q: [] }
    Alert.includes(:keywords).all.each do |alert|
      options[:q] << { id: alert.id, keywords: alert.keywords.map(&:name) }
    end

    options[:from] = date_range.from
    options[:to] = date_range.to
    options
  end

  def search_options(date_range)
    options = {}
    options[:q] = [ {id: self.id, keywords: self.keywords.map(&:name)} ]
    options[:from] = date_range.from
    options[:to] = date_range.to
    options
  end

  def self.apply_search date_range
    options = search_options(date_range)
    search_result = FeedEntry.search(options)

    search_result.alerts.each do |alert|
      alert.groups.each do |group|
        emails_to = []
        smses_to  = []

        group.members.each do |member|
          emails_to << member.email if member.email_alert
          smses_to  << member.phone if member.sms_alert
        end

        if emails_to.length > 0 && alert.total_match > 0
          search_results_by_alert = search_result.results_by_alert(alert.id)
          AlertMailer.notify_matched(search_results_by_alert, alert.id, group.name, emails_to, date_range).deliver_now
        end

        if smses_to.length > 0 && alert.total_match > 0
          smses_to.each do |sms|
            to = "sms://#{sms}"
            options = { from: ENV['APP_NAME'],
                        to: 'sms://0975553553',
                        body: "#{alert.name} has #{alert.total_match} feed #{'entry'.pluralize(alert.total_match)} matched your keywords" }
            SmsAlertJob.set(wait: 10.seconds).perform_later(options)
          end
        end
      end
    end

  end
end
