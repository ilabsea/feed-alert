# == Schema Information
#
# Table name: groups
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Group < ActiveRecord::Base
  belongs_to :user

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships

  has_many :alert_groups, dependent: :destroy
  has_many :alerts, through: :alert_groups

  has_many :group_permissions
  has_many :users, through: :group_permissions, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  strip_attributes only: [:name]

  def self.excludes(groups)
    where([" id not in (?)", groups])
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "name LIKE ? OR description LIKE ? ", like, like ])
  end

  def self.unique_members(groups)
    Member.joins(:memberships).where([" memberships.group_id  in (?)", groups]).uniq
  end

  def recipients(type)
    return members.pluck(type)
  end

end
