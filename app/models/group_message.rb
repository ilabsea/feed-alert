class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups
  
end
