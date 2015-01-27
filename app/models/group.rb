class Group < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships

  validates :name, presence: true
  validates :name, uniqueness: true
  
end
