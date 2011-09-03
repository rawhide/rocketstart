class ApprovalWorkflow < ActiveRecord::Base
  belongs_to :user
  belongs_to :approval
end
