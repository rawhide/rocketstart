#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def current_user
    user
  end
  helper_method :current_user

  def me?(user)
    current_user.id == user.id
  end
  helper_method :me?

  def roll_change?
    [::User::Administrator, ::User::President].include?(current_user.class)
  end
  helper_method :roll_change?

  private
  def login_required
    return true if authenticated?
    redirect_to root_path
  end
end
