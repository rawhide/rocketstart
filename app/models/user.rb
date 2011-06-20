class User < ActiveRecord::Base
  include Authentication
  attr_accessor :password, :password_confirmation

  validates :email, :uniqueness => true, :presence => true
  validates :name, :presence => true
  validates :password, :presence => true, :confirmation => true, :on => :create

  before_save :encrypt_password

  class << self
    def authenticate_email(email, password)
      return nil if email.blank? || password.blank?
      u = find_by_email(email)
      u && u.authenticated?(password) ? u : nil
    end
  end
end
