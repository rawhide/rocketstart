class ActivationToken < ActiveRecord::Base
  before_create :init

  private
  def init
    self.token = Digest::SHA1.hexdigest("--#{Time.now}--#{self.email}--")
  end
end
