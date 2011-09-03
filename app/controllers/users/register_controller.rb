#coding: utf-8
class Users::RegisterController < ApplicationController
  class TokenNotFound < StandardError; end
  before_filter :token_required

  rescue_from TokenNotFound do
    render :text => "token not found"
  end

  def new
    @user = ::User::find_by_email @token.email
  end

  def create
    @user = ::User::find_by_email @token.email
    u = User.authenticate(@user.email, params[:user][:password])

    if u
      ActiveRecord::Base::transaction do
        self.current_user= u
        @user.status = C.regist_status.REGISTED
        c = @user.company
        c.status = C.regist_status.REGISTED
        c.save!
        @user.save!
        @token.destroy
        DeliverMailer.registed(@user).deliver
        redirect_to dashboard_path and return
      end
    else
      flash[:error] = "パスワードが違います"
      render "new"
    end
  end

  private
  def token_required
    #@token = ActivationToken.find_by_code(params[:code])
    #TODO;sqlite?
    @token = ActivationToken.where([" code like ? ", "%#{params[:code]}%"]).first
    raise TokenNotFound unless @token.present?
  end

end
