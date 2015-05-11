class Group < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships

  has_many :alert_groups, dependent: :destroy
  has_many :alerts, through: :alert_groups

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.excludes(groups)
    where([" id not in (?)", groups])
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "name LIKE ? OR description LIKE ? ", like, like ])
  end
end
