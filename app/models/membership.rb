# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Membership < ActiveRecord::Base
  belongs_to :member
  belongs_to :group

  validates :member_id, :group_id, presence: true
  default_scope {order("memberships.created_at DESC")}

end
