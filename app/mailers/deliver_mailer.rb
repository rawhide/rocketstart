#encoding: utf-8
class DeliverMailer < ActionMailer::Base
  default :from => "from@example.com"

  def entry(entry)
    @entry = entry
    @url = Rails.configuration.site_url + register_with_token_path(:token => @entry.token)
    mail :to => @entry.email, :subject => '仮登録メール'
  end

  def registed(user)
    @user = user
    @url = Rails.configuration.site_url
    mail :to => @user.email, :subject => '登録完了メール'
  end

  def remined(entry)
    @entry = entry
    @url = Rails.configuration.site_url + register_remined_with_token_path(:token => @entry.token)
    mail :to => @entry.email, :subject => 'パスワード変更メール'
  end

end
