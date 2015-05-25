class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'sign_in'

  def new

  end

  def request_change
    reset_password_token = UserPasswordToken.new(params[:email])
    @user = reset_password_token.user

    if reset_password_token.apply
      flash.now[:notice] = "Instruction email has been sent to you"
    else
      flash.now[:alert] = "Invalid email, Please try again"
      render :new
    end
  end

  def change
    @user = User.find_by(reset_password_token: params[:t])
    if !@user
      redirect_to sign_in_path, alert: 'Expired link'
    end
  end

  # user reset_password_token as id in PUT /passwords
  def update
    user_password_update = UserPasswordUpdate.new(params[:t])
    if user_password_update.apply(params[:user])
      redirect_to sign_in_path, notice: 'Your password has been updated'
    else
      @user = user_password_update.user
      flash.now[:alert] = @user ? "Invalid User" : 'Failed to update password'
      render :change
    end
  end

end