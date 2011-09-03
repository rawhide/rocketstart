# coding: utf-8
class Schedules::GeneralController < ApplicationController

  def new
    @schedule = ::Schedule::NoLoop.new

    @start_year = params[:year] ? params[:year].to_i : 0
    @start_month = params[:month] ? params[:month].to_i : 0
    @start_day = params[:day] ? params[:day].to_i : 0
    @start_hour = params[:hour] ? params[:hour].to_i : 12
    @end_year = @start_year
    @end_month = @start_month
    @end_day = @start_day
    @end_hour = @start_hour + 1

    @users = User.where(:company_id => current_user.company_id)
  end

  def create
    loop_type, users = params_analize params
    @schedule = ::Schedule.factory loop_type
    @schedule.set_params ::Schedule::NoLoop::CONST, params
    @schedule.schedule_save users

    @year = @schedule.start_year
    @month = @schedule.start_month
    redirect_to(schedules_root_path(:year => @year, :month => @month-1), :notice => 'スケジュールを登録しました。')
  end

  def show
    @schedule = Schedule.find params[:id]
    @members = Array.new
    ::Relations::UsersSchedule.where(:schedule_id => @schedule.id).each do |us|
      user = User.find us.user_id
      if user.id != current_user.id
        @members << user
      end
    end
  end

  def edit
    @schedule = ::Schedule.find params[:id]

    @start_year = @schedule.start_year
    @start_month = @schedule.start_month
    @start_day = @schedule.start_day
    @start_hour = @schedule.start_hour
    @end_year = @schedule.end_year
    @end_month = @schedule.end_month
    @end_day = @schedule.end_day
    @end_hour = @schedule.end_hour

    @users = ::User.where(:company_id => current_user.company_id)
  end

  def update
    (loop_type, users, loop_update_type) = params_analize params
    schedule = ::Schedule.find params[:id]

    target = ::Schedule.find_by_action loop_update_type, schedule.id, schedule.loop_group_id

#    if schedule.update_without_loop_attr? loop_type, schedule, params
    if schedule.no_loop?
      target.each do |t|
        t.set_params_without_loop_attr schedule.class::CONST, params
        t.save_with_us users
      end
    else
      target.each { |t| t.destroy }
      @schedule = ::Schedule.factory loop_type
      @schedule.set_params schedule.class::CONST, params
      @schedule.schedule_save users
    end

    redirect_to(schedules_root_path, :notice => 'スケジュールを変更しました。')
  end

  def index
    year = params[:year]
    month = params[:month]
    day = params[:day]
    week = params[:week]
    params[:users] ? users = params[:users] : users = Array.new
    
    #TODO:yokohama ここで表示させたいメンバーのチェックボックス設定分だけusersに入れるようにする（今は全て入れいている）
    res = Array.new

    if month && day && week
      res = nil
    elsif month && day
      res = nil
    elsif month
      #raise Schedule.group_by_organization(current_user.company_id).inspect
      Schedule.group_by_organization(current_user.company_id).each do |s|
        res << {
                 :c_id => s.id,
                 :start_year => s.start_year, :start_month => s.start_month, :start_day => s.start_day, 
                 :start_hour => sprintf("%02d", s.start_hour), :start_minute => sprintf("%02d", s.start_minute),
                 :all_day => s.all_day,
                 :end_year => s.end_year, :end_month => s.end_month, :end_day => s.end_day, 
                 :end_hour => sprintf("%02d", s.end_hour), :end_minute => sprintf("%02d", s.end_minute),
                 :title => s.title
               }
      end
    end

    respond_to do |format|
      format.json { render :json => res }
    end
  end

  def destroy
    if params[:mine].present?
      schedule = ::Schedule.find params[:id]
      schedule.destroy
    else
      (loop_type, users, loop_update_type) = params_analize params
      schedule = ::Schedule.find params[:id]
      target = ::Schedule.find_by_action loop_update_type, schedule.id, schedule.loop_group_id
      target.each { |t| t.destroy }
    end
    redirect_to(schedules_root_path, :notice => 'スケジュールを削除しました。')
  end

  def loops
    @type = params[:type] ? params[:type] : ::Schedule::NoLoop::CONST
    @schedule = ::Schedule.find_by_id params[:id]
    @schedule = @schedule ? @schedule : ::Schedule.factory(@type)
    render 'loops', :layout => nil
  end

private

  #TODO:ohta update_というprefixは抽象的でないので抽象化したい
  def params_analize parms
    loop_type = parms[:loop_type] ? params[:loop_type] : ::Schedule::NoLoop::CONST

    users = parms[:users] ? parms[:users] : []
    users << current_user.id

    loop_update_type = ""
    if params[:update_mine]
      loop_update_type = "update_mine"
    elsif params[:update_after]
      loop_update_type = "update_after"
    elsif params[:update_all]
      loop_update_type = "update_all"
    end

    [loop_type, users, loop_update_type]
  end

end
