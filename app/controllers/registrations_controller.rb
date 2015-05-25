class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  layout "sign_in"

  def new
    @user = User.new
  end

  def create
    @user = User.new filter_params
    if UserRegistration.register(@user)
      redirect_to welcome_path(t: @user.confirmed_token), notice: "Please confirm your email"
    else
      flash.now[:alert] = "Failed to register"
      render :new
    end
  end

  def welcome
    @user = User.find_by(confirmed_token: params[:t])
    if !@user
      redirect_to sign_up_path, alert: 'Invalid User'
    end
  end

  def confirm
    if UserRegistration.confirm(params[:t])
      redirect_to sign_in_path, notice: 'Your account has been activated, Please sign in to start your project'
    else
      redirect_to sign_up_path, alert: 'Invalid User'
    end
  end
  
  private
  def filter_params
    params.require(:user).permit(:full_name, :email, :phone, :password, :password_confirmation)
  end
end