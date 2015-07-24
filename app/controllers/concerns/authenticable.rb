module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :remember_location
    before_action :authenticate_user!
    helper_method :current_user, :user_signed_in?
    
  end

  def remember_location
    if request.get? && !request.xhr? && !no_auth_path.include?(request.path)
      session[:remember_location] = request.fullpath
    end
  end

  def no_auth_path
    ['/sign_in', '/sign_up', '/confirm', '/welcome', '/sign_out', "/", 'passwords/new', '/users/reset',
     '/passwords/request_change', '/passwords/reset', '/passwords/change']
  end

  def current_user
    @current_user ||= User.find_by(auth_token: cookies.signed[cookie_access_name])
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to sign_in_path, alert: "You can not access this page, Please sign in"
    end
  end

  def after_signed_in_path_for(user)
    session[:remember_location] || root_path
  end

  def after_signed_out_path_for(user)
    root_path
  end

  def user_signed_in?
    current_user
  end

  def sign_in(user)
    if params[:remember_me]
      cookies.permanent.signed[cookie_access_name] = user.auth_token
    else
      cookies.signed[cookie_access_name] = user.auth_token
    end
  end

  def sign_out
    cookies.delete(cookie_access_name)
    @current_user = nil
  end

  def sign_in_and_redirect_for(user)
    sign_in(user)
    after_signed_in_path_for(user)
  end

  def sign_out_and_redirect_for(user)
    sign_out
    after_signed_out_path_for(user)
  end

  def cookie_access_name
    :_r_request
  end


end