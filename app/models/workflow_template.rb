class WorkflowTemplate < ActiveRecord::Base
  default_scope order(" step ASC")
  belongs_to :approval_form

  #userにワークフローをコピー
  def copy(user)
  end
end
