class ChannelSuggested

  def initialize channels
    @channels = channels
  end

  def by_phone phone
    phone_carrier = Tel.new(phone).carrier
    if phone_carrier
      @channels.each do |channel|
        return channel if channel["name"] == phone_carrier
      end
    end
    return @channels.first    
  end

end