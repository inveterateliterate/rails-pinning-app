class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_login
    redirect_to login_path unless logged_in?
  end

  def current_user
    @user ||= User.where(id: session[:user_id]).first
  end

  def logged_in?
    !current_user.nil? && !current_user.id.nil?
  end

  helper_method :current_user
  helper_method :logged_in?
end
