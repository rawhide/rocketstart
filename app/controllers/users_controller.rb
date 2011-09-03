# coding: utf-8
class UsersController < ApplicationController
  def index
    @users = User.where(company_id: current_user.company_id)
  end

  def edit
    @user = current_user.company.users.find params[:id]
  end

  def update
    @user = current_user.company.users.find params[:id]
    key = "user_" + @user.class.to_s.split("::").last.underscore

    User::transaction do
      if @user.update_attributes(params[key])
        @user.roll_change
        redirect_to users_path
      else
        render "edit"
      end
    end
  end

  def destroy
    #TODO:権限周りやその他、ひもづいている者を全て削除する
    u = User.find(params[:id])
    (::Schedule.where :owner_id => u.id).each do |s|
      s.destroy
    end
    (::UsersSchedule.where :user_id => u.id).each do |us|
      us.destroy
    end
    u.destroy
    redirect_to(users_url, :notice => 'ユーザーを削除しました。') 
  end
end
