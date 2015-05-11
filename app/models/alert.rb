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

  # accepts_nested_attributes_for :alert_places, allow_destroy: true

  INTERVAL_UNIT_HOUR = "Hour"
  INTERVAL_UNIT_DAY  = "Day"

  INTERVAL_UNITS = [INTERVAL_UNIT_HOUR, INTERVAL_UNIT_DAY]

  validates :name, presence: true
  validates :url, presence: true
  validates :from_time, :to_time, presence: true
  validates :from_time, numericality: {message: "must be less than To field"}, if: ->(u) { u.in_minutes(u.from_time) > u.in_minutes(u.to_time)}
  validates :to_time, numericality: {message: "must be greater than From field"}, if: ->(u) { u.in_minutes(u.from_time) > u.in_minutes(u.to_time)}

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

          # delay, delay_for, delay_unitl
          AlertMailer.delay_for(10.seconds).notify_matched(search_results_by_alert, alert.id, group.name, emails_to, date_range)
        end

        sms_time = Time.zone.now

        if smses_to.length > 0 && alert.total_match > 0 && is_time_appropiate?(sms_time)
          smses_to.each do |sms|
            options = { from: ENV['APP_NAME'], to: "sms://#{sms}", body: alert.translate_message }
            # wait_until, wait
            SmsAlertJob.set(wait: 10.seconds).perform_later(options)
          end
        end
      end
    end
  end

  def is_time_appropiate? sms_time
    working_minutes = sms_time.hour * 60 + sms_time.min
    self.in_minutes(self.from_time) <= working_minutes && working_minutes  <= self.in_minutes(self.to_time)
  end

  def in_minutes field
    field.split(":")[0].to_i * 60 + field.split(":")[1].to_i
  end

  def translate_message
    translate_options = {
      alert_name: self.name,
      total_match: self.total_match,
      keywords: self.keywords.map(&:name).join(", ")
    }

    StringSearch.instance.set_source(self.sms_template).translate(translate_options)
  end
end
