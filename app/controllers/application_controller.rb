class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :require_admin, :national_gateway_channels, :is_active_channel?
  protect_from_forgery with: :exception
  include Authenticable

  def default_serializer_options
    { root: false }
  end

  def require_admin
  	unless user_admin?
  		redirect_to root_url, alert: "You cannot access that part of the website."
  	end
  end

  def national_gateway_channels
    Channel.national_gateway
  end

end
