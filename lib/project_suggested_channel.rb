class ProjectSuggestedChannel

  def initialize project
    @project = project
  end

  def by_phone_number phone_number
    project_national_channels = @project.enabled_channels.select{ |channel| channel.global_setup? }
    phone_carrier = Tel.new(phone_number).carrier
    if phone_carrier
      project_national_channels.each do |channel|
        return channel if channel.name == phone_carrier
      end
    end
    return @project.enabled_channels.first   
  end

end