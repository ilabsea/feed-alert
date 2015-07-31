class UserPasswordUpdate
  attr_accessor :user

  def initialize(reset_password_token)
    @user = User.find_by(reset_password_token: reset_password_token)
  end

  def apply(options)
    return false unless @user
    @user.password = options[:password]
    @user.password_confirmation = options[:password_confirmation]
    @user.reset_password_token = nil
    @user.reset_password_at = Time.zone.now

    if @user.save
      delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i
      UserMailer.delay_for(delay_time.minute).password_changed(@user)
      true
    else
      false
    end
  end

end