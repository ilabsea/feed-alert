class ProjectChannel < ActiveRecord::Base
  belongs_to :project
  belongs_to :channel
  	
end
