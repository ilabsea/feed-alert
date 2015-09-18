class ChannelAccess < ActiveRecord::Base
  belongs_to :project
  belongs_to :channel
  	
end
