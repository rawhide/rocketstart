class ApprovalForm < ActiveRecord::Base
  has_many :fields, class_name: "ApprovalFormField"
  has_many :workflow_templates

  accepts_nested_attributes_for :workflow_templates

  has_many :approvals
  has_one :user
end
