class GroupPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :alert
  belongs_to :project

  before_save :set_order_number

  ORDER_NUMBER_ADMIN = 4
  ORDER_NUMBER_NORMAL = 2

  attr_accessor :max_order

  def set_order_number
    if self.role == User::PERMISSION_ROLE_ADMIN
      self.order_number = GroupPermission::ORDER_NUMBER_ADMIN
    else
      self.order_number = GroupPermission::ORDER_NUMBER_NORMAL
    end
  end


end
