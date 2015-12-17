# == Schema Information
#
# Table name: members
#
#  id          :integer          not null, primary key
#  full_name   :string(255)
#  email       :string(255)
#  phone       :string(255)
#  email_alert :boolean
#  sms_alert   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Member < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  belongs_to :user

  validates :full_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :phone, presence: true

  validates :email, email: {message: 'invalid format'}

  def self.excludes(members)
    where([" id not in (?)", members])
  end

  def self.from_query(query)
    like = "#{query}%"
    where([ "full_name LIKE ? OR email LIKE ? OR phone LIKE ? ", like, like, like ])
  end

end
