class ApplicationController < ActionController::Base

  #include AuthenticatedSystem
  protect_from_forgery

protected
  def current_user
    user
  end
  helper_method :current_user

private
  def login_required
    return true if authenticated?
    redirect_to login_path
  end

end
