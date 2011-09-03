# coding: utf-8
module ApplicationHelper

  def simple_date(yy, mm, dd, hh, m)
    if m.to_s.split(//u).length == 1
      str = yy.to_s + "年" + mm.to_s + "月" + dd.to_s + "日" + hh.to_s + ":0" + m.to_s
    else
      str = yy.to_s + "年" + mm.to_s + "月" + dd.to_s + "日" + hh.to_s + ":" + m.to_s
    end
  end

  def simple_time(time)
    time.strftime("%Y年%m月%d日 %H:%M")
  end

  #TODO: ごりがきなのであとでなおし
  def formatted_roll_options(options)
    admin = ::User::Administrator.first ? C.user_type.Administrator : nil
    sa = ::User::SystemOfficer.first ? C.user_type.SystemOfficer : nil
    ao = ::User::AuditOfficer.first ? C.user_type.AuditOfficer : nil
    pre = ::User::President.first ? C.user_type.President : nil

    delete_ids = [admin,sa,ao,pre].compact
    return options.map{|opt| opt unless delete_ids.include?(opt.last) }.compact
  end


end


