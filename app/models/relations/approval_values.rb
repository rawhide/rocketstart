class Relations::ApprovalValues < ActiveRecord::Base
  belongs_to :approval
  belongs_to :approval_form_field
end
