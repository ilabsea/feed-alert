class ObjectWithRole
  attr_accessor :object, :role
  def initialize(object, role=User::PERMISSION_ROLE_ADMIN )
    @object = object
    @role   = role
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
      @object.update_attributes(attributes)
    else
      false
    end
  end

  def save
    if has_admin_role?
      @object.save
    else
      false
    end
  end

  def destroy
    if has_admin_role?
      @object.destroy
    else
      false
    end
  end
end