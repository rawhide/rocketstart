#coding: utf-8
class Date
  class MonthOverFlowError < StandardError; end
  #params
  # @target: 対象の日付
  # @wday: 対象の曜日
  # @day_of_week: 対象の週番号（第X週)
  def self.get_day_of_week_in_month(target, wday, day_of_week)
    start = new target.year, target.month, 1

    result = new(target.year, target.month, 1)

    #1週目にない場合取得
    return nil if start.wday > wday && day_of_week == 1
    #一周目にある場合は起点取得
    day = start.wday == wday ? 1 : (start.wday - wday)
    result = new target.year, target.month, day

    while day_of_week > result.day_of_week_in_month
      result = result.since(7.days).to_date
      raise  MonthOverFlowError if start.month != result.month
    end
    return result
  rescue MonthOverFlowError
    return nil
  end

  def day_of_week_in_month
    hoge = ((self.day + (6- self.wday)).to_f / 7).ceil
  end
end
