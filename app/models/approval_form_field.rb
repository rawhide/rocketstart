class ApprovalFormField < ActiveRecord::Base
  has_many :approvals_approval_form_fields, :class_name => 'ApprovalsApprovalFormFields'
end
