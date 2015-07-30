class UserPasswordToken
  attr_accessor :user

  def initialize(email)
    @user = User.find_by(email: email.downcase)
  end

  def apply
    return false unless @user

    @user.generate_token_for(:reset_password_token)
    if @user.save
      UserMailer.change_password_instruction(@user).deliver_later
      true
    else
      false
    end
  end
end