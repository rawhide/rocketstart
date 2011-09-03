class Users::Invitation::RegisterController < ApplicationController
  class InvitationTokenNotFound < StandardError; end
  class UserTypeNotFound < StandardError; end
  before_filter :token_required, :except => [:complete]

  def new
    @user = user_klass(@token).new(email: @token.email)
    @company = @token.user.company
  end

  def create
    @user = user_klass(@token).new(email: @token.email, company_id: @token.company_id)
    @company = @token.user.company
    key = @user.class.to_s.split("::").last.underscore
    @user.attributes = params["user_#{key}".to_s]
    ActiveRecord::Base.transaction do
      if @user.save
        @user.status = C.regist_status.REGISTED
        @token.destroy
        DeliverMailer.registed(@user).deliver
        self.current_user= @user
        redirect_to complete_users_invitation_register_path and return
      else
        render "new"
      end
    end
  end

  private
  def token_required
    @token = ::InvitationToken.where(["code like ? ", "%#{params[:code]}%"]).first
    raise InvitationTokenNotFound unless @token.present?
  end

  #TODO:ohta
  #あとでアブストラクトファクトリー
  def user_klass(token)
    case token.user_type
    when 2
      ::User::President
    when 3
      ::User::EdicationalOfficer
    when 4
      ::User::SystemOfficer
    when 5
      ::User::Staff
    when 6
      ::User::AuditOfficer
    else
      raise UserTypeNotFound
    end
  end
end
