# coding: utf-8
module Schedules::GeneralHelper

  def simple_selectbox length, selected
    html = ""
    length.each do |i|
      if (selected == i)
        html += "<option value='" + i.to_s + "' selected>" + i.to_s + "</option>"
      else
        html += "<option value='" + i.to_s + "'>" + i.to_s + "</option>"
      end
    end
    html
  end

  def minute_selectbox selected=0
    html = ""
    html += "<option value='0'>00</option>"
    html += "<option value='0'>15</option>"
    html += "<option value='0'>30</option>"
    html += "<option value='0'>45</option>"
  end

  def loop_selectbox s
    html = "<select id='loop'>"
    html += (s.class::CONST == ::Schedule::NoLoop::CONST) ? 
              "<option value='" + ::Schedule::NoLoop::CONST + "' selected>くり返ししない</option>" : 
              "<option value='" + ::Schedule::NoLoop::CONST + "'>くり返ししない</option>"
    html += (s.class::CONST == ::Schedule::DayLoop::CONST) ? 
              "<option value='" + ::Schedule::DayLoop::CONST + "' selected>毎日</option>" : 
              "<option value='" + ::Schedule::DayLoop::CONST + "'>毎日</option>"
    html += (s.class::CONST == ::Schedule::WeekLoop::CONST) ? 
              "<option value='" + ::Schedule::WeekLoop::CONST + "' selected>毎週</option>" : 
              "<option value='" + ::Schedule::WeekLoop::CONST + "'>毎週</option>"
    html += (s.class::CONST == ::Schedule::MonthLoop::CONST) ? 
              "<option value='" + ::Schedule::MonthLoop::CONST + "' selected>毎月</option>" : 
              "<option value='" + ::Schedule::MonthLoop::CONST + "'>毎月</option>"
    html += (s.class::CONST == ::Schedule::YearLoop::CONST) ? 
              "<option value='" + ::Schedule::YearLoop::CONST + "' selected>毎年</option>" : 
              "<option value='" + ::Schedule::YearLoop::CONST + "'>毎年</option>"
    html += "</select>"
  end

end
