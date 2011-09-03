class Schedule::DayLoop < Schedule

  CONST = 'day_loop'.freeze

  def initialize(*args)
    super *args
    self.loop_unit = 1
  end

  def child_schedule_list 
    self.loop_unit = 1 if self.loop_unit.to_i <= 0
    self.loop_limit ||= self.start_date.dup.years_since(2)
    list = []
    #target_date = self.start_date.dup + self.loop_unit
    target_date = self.start_date.dup
    while((target_date <=> self.loop_limit) != 1)
      list << target_date
      target_date = target_date + self.loop_unit
    end
    list
  end

protected

  def extend_params(prms = {})
    {
      :loop_unit  => prms[:loop_unit],
      :loop_limit => prms[:loop_limit]
    }
  end

end
