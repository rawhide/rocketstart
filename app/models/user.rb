class User < ActiveRecord::Base
  include Authentication
  EditTargets = []
  RollName = ""
  attr_accessor :password, :password_confirmation, :roll

  validates :email, :uniqueness => true, :presence => true
  validates :name, :presence => true
  validates :password, :length => { :minimum => 6 }, :on => :create
  validates :password, :presence => true, :confirmation => true, :on => :create

  before_save :encrypt_password

  has_many :reports
  has_many :drop_boxes

  has_many :users_schedules, :class_name => 'Relations::UsersSchedule'
  has_one :profile, :class_name => '::User::Profile'

  accepts_nested_attributes_for :profile

  belongs_to :company

  class << self
    def authenticate_email(email, password)
      return nil if email.blank? || password.blank?
      u = find_by_email(email)
      u && u.authenticated?(password) ? u : nil
    end
  end

  def roll_change
    return if self.roll.blank?
    #TODO:あとでAbstractFactoryとvalidation
    type_text = 
    case self.roll.to_i
    when 1
      "User::Administrator"
    when 2
      "User::President"
    when 3
      "User::EdicationalOfficer"
    when 4
      "User::SystemOfficer"
    when 5
      "User::Staff"
    when 6
      "User::AuditOfficer"
    else
      raise UserTypeNotFound
    end
    self.class.update_all("type='#{type_text}'", ["id = ?", self.id])
  end

  def president?
    self.class == ::User::President
  end

  def user_type
    actor = self.class.to_s.split("::").last
    C.user_type.send(actor.to_sym)
  end

  def waiting_workflows
    ::ApprovalWorkflow.where(user_type: self.user_type)
  end
end
