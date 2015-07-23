class MigrationUser
  def self.start(user)
    project = Project.where(name: 'CDC', user_id: user.id).first_or_initialize
    project.save

    Alert.update_all(project_id: project.id)
    Group.update_all(user_id: user.id)
    Member.update_all(user_id: user.id)
  end
end