class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  helper_method :current_user

  protected

  def current_user
    if user_signed_in?
      @current_user ||= User.find(session[:user_id])
    end
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to sign_in_path, alert: "You need to sign in first"
    end
  end

  def after_signed_in_path_for(user)
    root_path
  end

  def after_signed_out_path_for(user)
    sign_in_path
  end

  def user_signed_in?
    session[:user_id].present?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def sign_out_and_redirect_for(user)
    sign_out
    after_signed_out_path_for(user)
  end

  def default_serializer_options
    { root: false }
  end
end
