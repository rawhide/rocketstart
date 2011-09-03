#coding: utf-8
class User::President < User
  ROLL = "社長".freeze
  RollOptions = [[::User::Administrator::ROLL,1],[::User::Staff::ROLL,5],[::User::AuditOfficer::ROLL,6]].freeze
  EditTargets = [::User::Administrator, ::User::Staff, ::User::AuditOfficer].freeze
end
