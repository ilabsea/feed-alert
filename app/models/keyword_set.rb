class KeywordSet < ActiveRecord::Base
  has_many :alert_keyword_sets, dependent: :destroy
  has_many :alerts, through: :alert_keyword_sets
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true

  strip_attributes only: [:name]

  def self.excludes(collections)
    where.not(id: collections)
  end

  def self.from_query(query)
    where([ "name LIKE ? ", "#{query}%"])
  end
end
