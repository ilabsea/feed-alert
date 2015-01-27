class Membership < ActiveRecord::Base
  belongs_to :member
  belongs_to :group
  
  default_scope {order("memberships.created_at DESC")}
end
