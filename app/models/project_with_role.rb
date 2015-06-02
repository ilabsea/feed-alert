class ProjectWithRole
  attr_accessor :project, :role
  def initialize(project, role=User::PERMISSION_ROLE_ADMIN )
    @project = project
    @role  = role
  end

  def has_admin_role?
    @role == User::PERMISSION_ROLE_ADMIN
  end

  def has_admin_role!
    if @role != User::PERMISSION_ROLE_ADMIN
      raise ActiveRecord::RecordNotFound
    end
  end

  def update_attributes attributes
    if has_admin_role?
      @project.update_attributes(attributes)
    else
      false
    end
  end

  def destroy
    if has_admin_role?
      @project.destroy
    else
      false
    end
  end
end