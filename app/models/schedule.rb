class Schedule < ActiveRecord::Base

  CONST = 'no_loop'.freeze

  has_many :users_schedules, :class_name => 'Relations::UsersSchedule'
  has_many :users, :through => :users_schedules
  
  composed_of :start_date, :class_name => 'ScheduleDateTime', :mapping => [%w(start_year year), %w(start_month month), %w(start_day day), %w(start_hour hour), %w(start_minute minute)]

  composed_of :end_date, :class_name => 'ScheduleDateTime', :mapping => [%w(end_year year), %w(end_month month), %w(end_day day), %w(end_hour hour), %w(end_minute minute)]

  def initialize(*arg)
    super *arg
    self.loop_limit = DateTime.now
  end
  
  #TODO: ABSFTY
  def self.factory str
    if str == ::Schedule::NoLoop::CONST
      s = ::Schedule::NoLoop.new
    elsif str == ::Schedule::DayLoop::CONST
      s = ::Schedule::DayLoop.new
    elsif str == ::Schedule::WeekLoop::CONST
      s = ::Schedule::WeekLoop.new
    elsif str == ::Schedule::MonthLoop::CONST
      s = ::Schedule::MonthLoop.new
    elsif str == ::Schedule::YearLoop::CONST
      s = ::Schedule::YearLoop.new
    end
    s ||= ::Schedule::NoLoop.new
  end

  def shift_type str
    if str == ::Schedule::NoLoop::CONST
      self.type = ::Schedule::NoLoop.to_s
    elsif str == ::Schedule::DayLoop::CONST
      self.type = ::Schedule::DayLoop.to_s
    elsif str == ::Schedule::WeekLoop::CONST
      self.type = ::Schedule::WeekLoop.to_s
    elsif str == ::Schedule::MonthLoop::CONST
      self.type = ::Schedule::MonthLoop.to_s
    elsif str == ::Schedule::YearLoop::CONST
      self.type = ::Schedule::YearLoop.to_s
    end
  end

  def self.find_by_action(action, id, loop_group_id)
    case action
    when 'update_mine', "mine"
      return self.where('id = ?', id)
    when 'update_after', "after"
      #TODO:なぜかlikeじゃないとstringがひかっからない。sqliteのもんだい？
      return self.where('id >= ? and loop_group_id like ?', id, "%#{loop_group_id}%")
    when 'update_all', "all"
      return self.where('loop_group_id like ?', "%#{loop_group_id}%")
    end
  end

  def set_params(loop_type, prms = {})
    self.attributes = self.common_params(prms["schedule_" + loop_type]).merge!(self.day_params(prms["schedule_" + loop_type])).merge!(self.extend_params(prms["loop"]))
  end

  def set_params_without_loop_attr(loop_type, prms = {})
    self.attributes = self.common_params(prms["schedule_" + loop_type])
  end

=begin
  def extend_params(prms = {})
    raise NotImplementedError
  end
=end

  def self.group_by_organization org_id
    find_by_sql(["select schedules.* from schedules " + 
                  " inner join users_schedules us on schedules.id = us.schedule_id " +
                  " inner join users on us.user_id = users.id and company_id = ?  " + 
                  " group by schedules.id", 
                org_id])
  end
  
  def change_loop_group_id(loop_type)
    return self.loop_group_id if self.new_record?
    self.loop_group_id = self.id unless self::CONST == loop_type
    self.loop_group_id
  end

  def save_with_us users=[]
    self.save!
    ::Relations::UsersSchedule.delete_all :schedule_id => self.id
    users.each { |u| ::Relations::UsersSchedule.create! :user_id => u, :schedule_id => self.id }
  end

  # createのみ
  def schedule_save(user_ids = [])

    child_date_list = self.child_schedule_list
#    begin
#      self.class.transaction do
        #self.save_with_us(user_ids)
        #self.loop_group_id = self.id
        #self.save!
    
        #TODO: ohta ユニークチェック
        #TODO: ohta DBに入るたちにsrandやめる ?
        self.loop_group_id = Digest::SHA1.hexdigest "---#{Time.now}---humstar"

        diff = (self.end_date - self.start_date)
        child_date_list.each do |d|
          child = self.dup
          child.start_date = d
          child.end_date = d.dup + Rational(diff, 1)
          child.save_with_us(user_ids)
          #child.loop_group_id = self.id
          child.save!
        end
#      end
#    rescue => e
#      return false
#    end
  end

  def owner
    ::User.find self.owner_id
  end

  def update_without_loop_attr?(loop_type=::Schedule::NoLoop::CONST, schedule=::Schedule.new, prms = {})
    loop = prms[:loop] ? prms[:loop] : {}
    loop[:loop_limit] = "1977/4/19" if loop[:loop_limit].blank?
    ll = loop[:loop_limit].split(/\//)
    limit_date = DateTime.new(ll[0].to_i, ll[1].to_i, ll[2].to_i)

    (loop_type == schedule.class::CONST) &&
    (prms[:loop][:loop_unit].to_i == schedule.loop_unit) &&
    (limit_date.year == schedule.loop_limit.year) &&
    (limit_date.day == schedule.loop_limit.day) &&
    (prms["schedule_" + loop_type][:start_year].to_i == schedule.start_year) &&
    (prms["schedule_" + loop_type][:start_month].to_i == schedule.start_month) &&
    (prms["schedule_" + loop_type][:start_day].to_i == schedule.start_day) &&
    (prms["schedule_" + loop_type][:end_year].to_i == schedule.end_year) &&
    (prms["schedule_" + loop_type][:end_month].to_i == schedule.end_month) &&
    (prms["schedule_" + loop_type][:end_day].to_i == schedule.end_day)
  end

  def no_loop?
    self.class == ::Schedule::NoLoop
  end

protected

  def child_schedule_list
    raise NotImplementedError
  end

  def extend_params(prms = {})
    raise NotImplementedError
  end
  
  def day_params(prms = {})
    {
      :start_year => prms[:start_year],
      :start_month => prms[:start_month],
      :start_day => prms[:start_day],
      :end_year => prms[:end_year],
      :end_month => prms[:end_month],
      :end_day => prms[:end_day]
    }
  end

  def common_params(prms = {})
    {
      :title => prms[:title],
      :memo  => prms[:memo],
      :owner_id => prms[:owner_id],
      :all_day => prms[:all_day],
      :start_hour => prms[:start_hour],
      :start_minute => prms[:start_minute],
      :end_hour => prms[:end_hour],
      :end_minute => prms[:end_minute]
    }
  end

end
