#coding: utf-8
class Users::ReminedController < ApplicationController

  def new
    @entry = ActivationToken.new
    @entry.remined = 1
    render :new
  end

  def create
    @entry = ActivationToken.new
    @entry.attributes = params[:activation_token]
    @entry.save!
    if @entry.remined?
      user = User.find_by_email @entry.email
      if user
        DeliverMailer.remined(@entry).deliver
      else
        #ここにユーザー登録されていない場合の処理を書く
      end
    else
      DeliverMailer.entry(@entry).deliver
    end
    render :complete
  end

  def edit
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
    @user.save!
    ActivationToken.find_by_email(u.email).destroy
    self.current_user = @user
    redirect_to dashboard_path
  end

end
