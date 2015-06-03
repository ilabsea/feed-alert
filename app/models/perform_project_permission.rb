class PerformProjectPermission
  def initialize(owner)
    @user = owner
  end

  def for_project(attrs)
    project_id = attrs[:project_id]
    if @user.accessible_project(project_id)
      group_permissions = GroupPermission.where(user_id: attrs[:user_id], project_id: attrs[:project_id])

      project_permission = ProjectPermission.where(user_id: attrs[:user_id], project_id: attrs[:project_id]).first_or_initialize

      if attrs[:role] == User::PERMISSION_ROLE_NONE
        if project_permission.persisted?
          project_permission.destroy!
          group_permissions.destroy_all
        end

      else
        project_permission.role = attrs[:role]
        project_permission.save!

        project_permission.project.alerts.each do |alert|
          alert.alert_groups.each do |alert_group|
            group_permission = GroupPermission.where(user_id: attrs[:user_id],
                                                     group_id: alert_group.group_id,
                                                     alert_id: alert_group.alert_id,
                                                     project_id:attrs[:project_id]).first_or_initialize
            group_permission.role = project_permission.role

            group_permission.save!
          end
        end
      end

    end
  end

end