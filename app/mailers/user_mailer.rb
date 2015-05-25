class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    subject = "#{ENV['APP_NAME']} account confirmation"
    roadie_mail(to: @user.email, subject: subject)
  end

  def welcome(user)
    @user = user
    subject = "#{ENV['APP_NAME']}'s account activated"
    roadie_mail(to: @user.email, subject: subject)
  end

  def change_password_instruction(user)
    @user = user
    subject = "#{ENV['APP_NAME']} change password instruction "
    roadie_mail(to: @user.email, subject: subject)
  end

  def password_changed(user)
    @user = user
    subject = "#{ENV['APP_NAME']} account password changed"
    roadie_mail(to: @user.email, subject: subject)
  end
end