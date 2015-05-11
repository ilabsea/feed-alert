class Member < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true

  def self.excludes(members)
    where([" id not in (?)", members])
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "full_name LIKE ? OR email LIKE ? OR phone LIKE ? ", like, like, like ])
  end
end
