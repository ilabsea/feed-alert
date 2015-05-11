class Keyword < ActiveRecord::Base
  has_many :alert_keywords, dependent: :destroy
  has_many :alerts, through: :alert_keywords

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.excludes(collections)
    where([" id not in (?)", collections])
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "name LIKE ? ", like])
  end
end
