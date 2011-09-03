#coding: utf-8
class Users::EmailController < ApplicationController
  before_filter :token_required, :only => [:edit, :update]

  def edit
    @user = @token.user
  end

  def create
    token = EmailChangeToken.new(user_id: current_user.id, email: params[:email])
    User::transaction do
      if token.save
        DeliverMailer.email_change(token).deliver
        redirect_to send_complete_users_email_path and return
      else
        render "users/edit"
      end
    end
  end

  def update
    @user = @token.user
    u = User.authenticate(@user.email, params[:password])
    if u && @user.id == u.id
      User::transaction do
        @user.email = @token.email
        @user.save!
        @token.destroy
        redirect_to complete_users_email_path and return
      end
    else
      flash[:error] = "パスワードが違います"
      render "edit"
    end
  end

  def complete; end

  def send_complete; end

  private
  def token_required
    @token = ::EmailChangeToken.where(["code like ? ", "%#{params[:code]}%"]).first
  end

end
