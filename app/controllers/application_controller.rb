class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  def require_login
    redirect_to login_path unless current_user
  end
  def require_role(*roles)
    return true if roles.include?(current_user.role)
    head :forbidden
    false
  end
  def not_found
    head :not_found
  end
end
