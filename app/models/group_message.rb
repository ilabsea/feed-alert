class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receivers
  
end
