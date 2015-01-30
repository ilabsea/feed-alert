class AlertPlace < ActiveRecord::Base
  belongs_to :alert, counter_cache: true
  belongs_to :place

  attr_accessor :place_selected
end
