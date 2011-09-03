#coding: utf-8
#通知用mailer
class NoticeMailer < ActionMailer::Base
  default :from => "from@example.com"

  class << self
    def put_mails(wf)
      #メールを送る
      user_klass(wf.user_type).all.each do |u|
        ::NoticeMailer.workflow_notice(u, wf).deliver
      end
    end
  end

  def workflow_notice(u, wf)
    @approval_form = wf.approval_form
    mail :to => u.email, :subject => "[humstar]未承認の申請書があります。申請書名：#{wf.approval_form.name}"
  end

  private

  #TODO:あとでABSTF
  def user_klass(user_type)
    klass = 
    case user_type
    when 1
      User::Administrator
    when 2
      User::President
    when 3
      User::EdicationalOfficer
    when 4
      User::SystemOfficer
    when 5
      User::Staff
    when 6
      User::AuditOfficer
    else
      raise UserTypeNotFound
    end
  end
end
