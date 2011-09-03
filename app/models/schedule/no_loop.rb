class Schedule::NoLoop < Schedule

  def child_schedule_list
    [self.start_date]
  end

protected

  def extend_params(prms = {})
    {}
  end

end
