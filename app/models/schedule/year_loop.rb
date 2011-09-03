class Schedule::YearLoop < Schedule

  CONST = 'year_loop'.freeze

  def initialize(*args)
    super *args
    self.loop_limit = Time.now.since(1.years)
  end

  def loops(options={})
    @unit = options[:unit]
    @limit = options[:limit]
  end

  def child_schedule_list 
    self.loop_unit = 1 if self.loop_unit.to_i <= 0
    list = []
    target_date = self.start_date.dup.to_date
    loop_limit = self.loop_limit.to_date

    while((target_date <=> loop_limit) != 1)
      list << target_date
      target_date = target_date.since(self.loop_unit.years).to_date
    end
    list
  end

  protected

  def extend_params(param)
    {
      loop_limit: param[:loop_limit],
      loop_unit: param[:unit]
    }
  end

end
