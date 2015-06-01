class Permission < ActiveRecord::Base
  belongs_to :permissible, polymorphic: true
end
