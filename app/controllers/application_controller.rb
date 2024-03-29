class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
    @username = Current.user&.username
  end

  def require_login
    redirect_to login_path, alert: 'You must be signed in' if Current.user.nil?
  end
end
