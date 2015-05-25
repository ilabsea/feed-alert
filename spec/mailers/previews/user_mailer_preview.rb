class UserMailerPreview < ActionMailer::Preview
  def registration
    UserMailer.registration(user)
  end

  def welcome
    UserMailer.welcome(user)
  end

  def change_password_instruction
    UserMailer.change_password_instruction(user)
  end

  def password_changed
    UserMailer.password_changed(user)
  end

  def user
    Struct.new("User", :id, :email, :full_name, :confirmed_token, :reset_password_token)
    Struct::User.new(1, "preview@feedalert.com", "Channa Ly", "13fasd1dac4378", "adc12360937fabbd")
  end

end