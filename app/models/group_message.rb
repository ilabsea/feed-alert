class GroupMessage < ActiveRecord::Base
  belongs_to :user

  serialize :receiver_groups

  def send
  	GroupMessageResult.instance().run
  end
  
end
