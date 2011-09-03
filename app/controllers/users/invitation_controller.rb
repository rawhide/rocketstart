#coding: utf-8
class Users::InvitationController < ApplicationController
  def new
    @invitation = ::InvitationToken.new(user_id: current_user.id)
  end

  def create
    @invitation = ::InvitationToken.new(user_id: current_user.id, company_id: current_user.company.id)
    @invitation.attributes = params[:invitation_token]

    ActiveRecord::Base::transaction do
      if @invitation.save
        flash[:notice] = "invitationしました"
        DeliverMailer.invitation(@invitation).deliver
        redirect_to(users_path) and return
      else
        render("new") and return
      end
    end
  end
end
