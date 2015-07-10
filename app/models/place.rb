# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Place < ActiveRecord::Base
  has_many :alert_places
  has_many :alerts, through: :alert_places
  validates :name, presence: true, uniqueness: true
end
