#coding: utf-8
class SessionsController < ApplicationController

  def new
  end

  def create
    authenticate!
    redirect_to home_path
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
