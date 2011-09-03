#coding: utf-8
class InvitationToken < ActiveRecord::Base
  RollOptions = [["個人情報保護責任者",1],["社長", 2], ["教育責任者",3],["情報システム・リスク責任者",4],["従業員",5],["監査責任者", 6]].freeze
  belongs_to :user
  before_create :init

  private
  def init
    self.code = Digest::SHA1.hexdigest("--#{Time.now}--#{self.email}--")
  end
end
