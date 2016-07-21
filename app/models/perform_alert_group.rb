class PerformAlertGroup
  attr_accessor :role
  def initialize(options)
    @options = options
  end

  def create
    alert = Alert.includes(project: [:project_permissions]).find(@options[:alert_id])
    alert_group = alert.alert_groups.build(group_id: @options[:group_id])
    if alert_group.save
      alert.project.project_permissions.each do |project_permission|
        role = project_permission.role
        group_permission = GroupPermission.new(user_id: project_permission.user_id,
                                               group_id: @options[:group_id],
                                               alert_id: alert.id,
                                               project_id: alert.project_id,
                                               role: role)
        group_permission.save!
      end
    end
    alert_group
  end

  def destroy
    alert = Alert.find(@options[:alert_id])
    alert_group = alert.alert_groups.find(@options[:id])

    group_permissions = GroupPermission.where(group_id: alert_group.group_id,
                                              alert_id: alert_group.alert_id)

    alert_group.destroy!
    group_permissions.destroy_all

  end

end
