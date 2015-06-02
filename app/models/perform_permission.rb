class PerformPermission
  def initialize(owner)
    @user = owner
  end

  def for_project(attrs)
    project_id = attrs[:project_id]
    if @user.accessible_project(project_id)
      p "accessible to project:"

      permission = ProjectPermission.where(user_id: attrs[:user_id], project_id: attrs[:project_id]).first_or_initialize
      p "permission"
      p permission
      p attrs[:role]

      if attrs[:role] == User::PERMISSION_ROLE_NONE
        permission.destroy if permission.persisted?
      else
        permission.role = attrs[:role]
        permission.save!
      end
    end
  end

end