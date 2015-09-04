class AddIsEnabledNationalGatewayToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_enabled_national_gateway, :boolean, :default => false
  end
end
