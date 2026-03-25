class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

      store_location
      redirect_to login_path, alert: "You must be logged in to access this section"
  end

  def require_admin
    return if logged_in? && current_user.admin?
      redirect_to root_path, alert: "You do not have permission to access this section"
  end

  def require_client
    return if logged_in? && current_user.client.present?

    redirect_to root_path, alert: "Only clients can access this section"
  end

  def require_self_or_admin(user)
    return if logged_in? && (current_user.id == user.id || current_user.admin?)
      redirect_to root_path, alert: "You do not have permission to access this section"
  end

  def store_location
    return unless request.get?
    return if request.path.in?([login_path, signup_path, logout_path])

    session[:forwarding_url] = request.original_url
  end

  def require_developer
    return if logged_in? && current_user.developer.present?
    
    redirect_to root_path, alert: "Only developers can access this section"
  end
end
