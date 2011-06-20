#coding: utf-8
class RegisterController < ApplicationController
  class TokenNotFound < StandardError; end

  def new
    @entry = ActivationToken.find_by_token(params[:token])
    if @entry
      @user = User.new({:email => @entry.email})
    else
      raise TokenNotFound
    end
  end

  def create
    @user = User.new
    @user.attributes = params[:user]
    DeliverMailer.registed(@user).deliver
    login @user
  end

  def remined
    @entry = ActivationToken.find_by_token(params[:token])
    if @entry
      @user = User.find_by_email @entry.email
    else
      raise TokenNotFound
    end
  end

  def update
    @user = User.find_by_email params[:user][:email]
    @user.attributes = params[:user]
    login @user
  end

private
  def login u
    u.save!
    at = ActivationToken.find_by_email u.email
    at.destroy
    self.current_user = u
    redirect_to home_path
  end
end
