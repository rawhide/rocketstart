class EmailChangeToken < ActiveRecord::Base
  belongs_to :user
  before_create :init
  private
  def init
    self.code = Digest::SHA1.hexdigest("--#{Time.now}--#{self.email}--")
  end
end
