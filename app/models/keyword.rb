class Keyword < ActiveRecord::Base
  has_many :alert_keywords, dependent: :destroy
  has_many :alerts, through: :alert_keywords

  validates :name, presence: true
  validates :name, uniqueness: true
end
