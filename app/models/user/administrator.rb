#coding: utf-8
class User::Administrator < User
  ROLL = "管理者".freeze
  RollOptions = [[::User::Administrator::ROLL,1],[::User::EdicationalOfficer::ROLL,3],[::User::SystemOfficer::ROLL,4],[::User::Staff::ROLL,5]].freeze
  EditTargets = [::User::EdicationalOfficer, ::User::SystemOfficer, ::User::Staff].freeze
  has_many :reports, :class_name => "ApprovalForm", :foreign_key => :user_id
end
