class Schedule::WeekLoop < Schedule

  CONST = 'week_loop'.freeze

  def initialize(*arg)
    super *arg
    self.loop_week_days = ""
  end

  def child_schedule_list 
    self.loop_unit = 1 if self.loop_unit.to_i <= 0
    self.loop_limit ||= self.start_date.dup.years_since(2)
    list = []
    #target_date = self.next_sunday self.start_date, (self.loop_unit - 1)
    target_date = self.start_date.dup
    while((target_date <=> self.loop_limit) != 1)
      self.this_week(target_date).each { |w| list << w }
      target_date = self.next_sunday target_date, (self.loop_unit - 1)
    end
    list
  end

  def update_without_loop_attr?(loop_type=::Schedule::NoLoop::CONST, schedule=::Schedule.new, prms = {})
    super && (prms["schedule_" + loop_type][:loop_week_days].to_i == schedule.loop_week_days) 
  end

=begin
  {:sunday_checked? => "0", :monday_checked? => "1"}.each do |mname, youbi|
    define_method(mname) do
      res = false
      self.loop_week_days.split(/,/)).each {|w| res = true if w == youbi }
      res
    end
  end
=end

  def sunday_checked?
    res = false
    (self.loop_week_days.split(/,/)).each {|w| res = true if w == "7" }
    res
  end

  def monday_checked?
    res = false
    (self.loop_week_days.split(/,/)).each {|w| res = true if w == "1" }
    res
  end
  def tuesday_checked?
    res = false
    (self.loop_week_days.split(/,/)).each {|w| res = true if w == "2" }
    res
  end
  def wednesday_checked?
    res = false
    (self.loop_week_days.split(/,/)).each {|w| res = true if w == "3" }
    res
  end
  def thursday_checked?
    res = false
    (self.loop_week_days.split(/,/)).each {|w| res = true if w == "4" }
    res
  end
  def friday_checked?
    res = false
    (self.loop_week_days.split(/,/)).each {|w| res = true if w == "5" }
    res
  end
  def saturday_checked?
    res = false
    (self.loop_week_days.split(/,/)).each {|w| res = true if w == "6" }
    res
  end

  def week_days
    res = []
    self.loop_week_days.split(/,/).each { |w| res << w.to_i }
    res
  end

protected

  def extend_params(prms = {})
    _loop_week_days = ""
    if prms[:loop_week_days].present?
      prms[:loop_week_days].each { |lwd| _loop_week_days += (lwd + ",") }
      _loop_week_days = _loop_week_days.chop
    end
    
    {
      :loop_unit  => prms[:loop_unit],
      :loop_limit => prms[:loop_limit],
      :loop_week_days => _loop_week_days
    }
  end

  def next_sunday d=Date.now, hop_week_count=0
    d.dup + (((7 - (d.cwday)) + 1) + (hop_week_count * 7))
  end

  def this_week point=DateTime.now
    target = []
    1..7.times do |i|
      wd = point.dup + (i - point.cwday)
      self.week_days.each { |w| target << wd if w == wd.cwday }
    end
    target
  end

end
