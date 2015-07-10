# == Schema Information
#
# Table name: group_permissions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  group_id     :integer
#  alert_id     :integer
#  project_id   :integer
#  role         :string(255)
#  order_number :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
