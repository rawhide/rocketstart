#coding: utf-8
class EntriesController < ApplicationController

  def confirm; end

  def new
    @entry = ActivationToken.new
  end

  def remined
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
  end

end
