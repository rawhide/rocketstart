class Approval < ActiveRecord::Base
  class ApprovalTargetNotFound < StandardError; end
  belongs_to :user
  belongs_to :approval_form

  has_many :fields, class_name: '::Relations::ApprovalValues'

  has_many :workflows, class_name: "ApprovalWorkflow" do
    def completed?
      where(accept: false).blank?
    end
  end

  def workflows=(templates)
    templates.each do |temp|
      self.workflows.create step: temp.step, user_type: temp.user_type, user_id: self.user_id
    end
  end

  def accepted?(user)
    ret = false
    if target_flow = workflows.where(user_type: user.user_type).first
      ret = target_flow.accept?
    else
      raise ApprovalTargetNotFound
    end
    return ret
  end

  def read_only?(user)
    ret = true
    return ret if workflows.completed?
    if target_flow = workflows.where(user_type: user.user_type).first
      ret = workflows.where([" step > :step AND accept = :accept ", {step: target_flow.step, accept: true}]).first ? true : false
      #もし1ステップ目ならfalse
      #もし前段階の承認が残っていたらfalse
      if target_flow.step == 1 && !target_flow.accept?
        ret = false
      else
        ret = true unless workflows.where(["step <= :step AND accept = :accept", { :step => target_flow.step, :accept => true}]).all.present?
      end
    else
      #通常ありえないので例外
      raise ApprovalTargetNotFound
    end
    return ret
  end
end
