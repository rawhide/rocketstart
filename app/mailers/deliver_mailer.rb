#encoding: utf-8
class DeliverMailer < ActionMailer::Base
  default :from => "from@example.com"

  def entry(entry)
    @entry = entry
    @url = users_register_with_token_url(:code => @entry.code)

    mail :to => @entry.email, :subject => '仮登録メール'
  end

  def registed(user)
    @user = user
    @url = root_url
    mail :to => @user.email, :subject => '登録完了メール'
  end

  def remined(entry)
    @entry = entry
    @url = "http://dailyreport.heroku.com" +  register_remined_with_token_path(:token => @entry.token)
    mail :to => @entry.email, :subject => 'パスワード変更メール'
  end

  def invitation(entry)
    @entry = entry
    mail :to => @entry.email, :subject => '[humstar]招待'
  end

  def email_change(token)
    @token = token
    @url = users_email_change_url(:code => token.code)
    mail :to => @token.email, :subject => "[humstar]emailの変更通知"
  end

end
