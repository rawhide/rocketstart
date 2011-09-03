#coding: utf-8
class Schedule::MonthLoop < Schedule
  class NotDefinedLoopType < RuntimeError; end
  attr_accessor :loop_month_unit_type

  CONST = 'month_loop'.freeze

  module LoopMonthUnitType
    Day = "0"
    CalDay = "1"
  end

  def loops(options={})
    @unit = options[:unit]
    @limit = options[:limit]
    @month_unit = options[:month_unit]
  end

  def child_schedule_list 
    list = []
    self.loop_unit = 1 if self.loop_unit.to_i <= 0
    self.loop_limit ||= self.start_date.dup.years_since(2)

    target_date = self.start_date.dup.to_date
    loop_limit = self.loop_limit.to_date
    while((target_date <=> loop_limit) != 1)
      list << target_date
      target_date = inclement_target target_date, self.loop_unit, self.start_date
      break if target_date.blank?
    end
    list
  end

  protected

  def extend_params(params)
    {
      loop_unit: params[:loop_unit],
      loop_month_unit_type: params[:loop_month_unit_type],
      loop_limit: params[:loop_limit],
    }
  end

  def get_week(target_date)
  end


  private

  def inclement_target(target, unit, original)
    next_month = target.since(unit.month)

    case self.loop_month_unit_type
    when LoopMonthUnitType::Day
      next_target = Date.new( next_month.year, next_month.month, next_month.day )
    when LoopMonthUnitType::CalDay
      next_target = Date.get_day_of_week_in_month next_month, original.wday, original.day_of_week_in_month
    else
      raise NotDefinedLoopType.new("不正なパラメータを受信")
    end
    return next_target
  end
end
