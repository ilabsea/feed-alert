class Alert < ActiveRecord::Base
  has_many :alert_groups, dependent: :destroy
  has_many :groups, through: :alert_groups

  has_many :alert_keywords, dependent: :destroy
  has_many :keywords, through: :alert_keywords

  has_many :alert_places, dependent: :destroy
  has_many :places, through: :alert_places

  accepts_nested_attributes_for :alert_places, allow_destroy: true #, reject_if: proc { |attributes| attributes['place_selected'] == '0' },

  INTERVAL_UNIT_HOUR = "Hour"
  INTERVAL_UNIT_DAY  = "Day"

  INTERVAL_UNITS = [INTERVAL_UNIT_HOUR, INTERVAL_UNIT_DAY]

  validates :name, presence: true
  validates :url, presence: true
  validates :interval, presence: true, numericality: {greater_than: 0}
  validates :email_template, presence: true
  validates :sms_template, presence: true

  # def form_alert_places
  #   place_ids = self.alert_places.map(&:place_id)
  #   alert_places = []
  #   Place.order("name DESC").all.each do |place|
  #     found = false
  #     @alert.alert_places.each do |alert_place|
  #       if alert_place.place_id == place.id
  #         alert_places << alert_place
  #         found = true
  #       end
  #     end
  #     alert_places << @alert.alert_places.build(place_id: place.id) unless found
  #   end
  #   @alert.form_alert_places = alert_places
  # end

end
