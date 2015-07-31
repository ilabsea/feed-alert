class UserPasswordToken
  attr_accessor :user

  def initialize(email)
    @user = User.find_by(email: email.downcase)
  end

  def apply
    return false unless @user

    @user.generate_token_for(:reset_password_token)
    if @user.save
      delay_time = ENV['DELAY_DELIVER_IN_MINUTES'].to_i
      UserMailer.delay_for(delay_time.minute).change_password_instruction(@user)
      true
    else
      false
    end
  end
end