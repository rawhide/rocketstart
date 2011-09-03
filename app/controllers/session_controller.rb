class SessionController < ApplicationController
  def create
    authenticate!
    redirect_to dashboard_path
  end

  def destroy
    logout
    redirect_to root_path
  end

  def unauthenticated
    flash[:notice] = warden.message
    redirect_to root_path
  end
end
