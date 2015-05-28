module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    helper_method :current_user, :user_signed_in?
  end

  def current_user
    if user_signed_in?
      @current_user ||= User.find_by(auth_token: cookies[:auth_token])
    end
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to sign_in_path, alert: "You can not access this page, Please sign in"
    end
  end

  def after_signed_in_path_for(user)
    root_path
  end

  def after_signed_out_path_for(user)
    root_path
  end

  def user_signed_in?
    cookies[:auth_token].present?
  end

  def sign_in(user)
    if params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end

  def sign_out
    cookies.delete(:auth_token)
  end

  def sign_in_and_redirect_for(user)
    sign_in(user)
    after_signed_in_path_for(user)
  end

  def sign_out_and_redirect_for(user)
    sign_out
    after_signed_out_path_for(user)
  end


end