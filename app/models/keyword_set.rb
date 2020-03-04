class KeywordSet < ActiveRecord::Base
  has_many :alert_keyword_sets, dependent: :destroy
  has_many :alerts, through: :alert_keyword_sets

  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true

  strip_attributes only: [:name]

  def self.excludes(collections)
    where([" id not in (?)", collections])
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "name LIKE ? ", like])
  end
end
