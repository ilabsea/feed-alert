class Place < ActiveRecord::Base
  has_many :alert_places
  has_many :alerts, through: :alert_places
  validates :name, presence: true, uniqueness: true
end
