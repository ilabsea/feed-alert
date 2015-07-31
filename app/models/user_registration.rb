class UserRegistration

  def self.register user
    if user.save
      delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i
      UserMailer.delay_for(delay_time.minute).registration(user)
      true
    else
      false
    end
  end

  def self.confirm confirmed_token
    user = User.find_by(confirmed_token: confirmed_token)
    if user
      user.confirmed_at = Time.zone.now
      user.confirmed_token = nil
      if user.save
        delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i
        UserMailer.delay_for(delay_time).welcome(user)
        true
      else
        false
      end
    else
      false
    end
  end

end