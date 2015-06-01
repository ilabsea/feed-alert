class PerformPermission
  def initialize(owner)
    @user = owner
  end

  def for_project(attrs)
    project_id = attrs[:project_id]
    if @user.accessible_project(project_id)
      permission = ProjectPermission.where(user_id: attrs[:user_id], project_id: attrs[:project_id]).first_or_initialize
      permission.role = attrs[:role]
      permission.save!
      permission
    else
      nil
    end
  end

end