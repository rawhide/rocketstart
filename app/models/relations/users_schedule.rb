class Relations::UsersSchedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule
  belongs_to :owner, :class_name => 'User', :foreign_key => :owner_id

  def self.joind? user_id, schedule_id
    self.find_by_user_id_and_schedule_id(user_id, schedule_id)
  end

end
