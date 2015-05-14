class StatsController < ApplicationController

  before_filter :authorize_admin


  def index
  end


  def show
    @teams = Team.all
    @categories = Category.all

    # get user's fullname (map array of hashes to method name)
    require 'ostruct'
    @userz = User.all.map { |u| ["#{u.first_name} #{u.last_name}", u.id] }
    @users = Array.new
    @userz.each do |name, id|
      @userzz = Hash.new
      @userzz["fullname"] = name
      @userzz["id"] = id
      @userzzz = OpenStruct.new @userzz
      @users.push(@userzzz)
    end
    # pp @users.first.fullname


    if params[:id] == 'user'
      render 'user'
    elsif params[:id] == 'users'
      render 'users'
    elsif params[:id] == 'team'
      render 'team'
    elsif params[:id] == 'category'
      render 'category'
    elsif params[:id] == 'categories'
      render 'categories'
    else
      puts "condition_catched!"
    end
  end


  def reports
    # selected time range
    if params[:date_custom] != ""
      @date = Time.strptime(params[:date_custom],"%m/%d/%Y")
    elsif params[:date] == "last_week"
      @date = 1.weeks.ago
    elsif params[:date] == "last_month"
      @date = 1.months.ago
    elsif params[:date] == "last_year"
      @date = 1.years.ago
    else
      @date = 1.seconds.ago
    end

    # reports filter for team
    if params[:team_id]
      @team_users = User.where("team_id = ?", params[:team_id])
      @stats = Array.new
      @team_users.each do |user|
        @stats.push(Report.where("user_id = ? AND created_at >= ?", user.id, @date))
      end
      @hours = Array.new
      @stats.to_a.each do |report|
        report.each do |rr|
          puts "pushing #{rr.inspect}"
          @hours.push(Hour.where(report_id: rr.id))
          puts "pushed #{rr.id}"
        end
      end
    # reports filter for single category
    elsif params[:category_id]
      @category_hours = Hour.where("category_id = ?", params[:category_id])
      @stats = Array.new
      @category_hours.each do |c_hour|
        @stats.push(Report.where("id = ? AND created_at >= ?", c_hour.report_id, @date))
      end
      @hours = Array.new
      @stats.to_a.each do |report|
        report.each do |rr|
          puts "pushing #{rr.inspect}"
          @hours.push(Hour.where(report_id: rr.id))
          puts "pushed #{rr.id}"
        end
      end
    # reports filter for single user
    elsif params[:user_id]
      @stats = Report.where("user_id = ? AND created_at >= ?", params[:user_id], @date)
      @hours = Array.new
      @stats.to_a.each do |report|
        puts "pushing #{report.inspect}"
        @hours.push(Hour.where(report_id: report.id))
        puts "pushed #{report.id}"
      end
    else
    end

    # time calculation
    @total_hours = 0
    @hours.each do |report|
      report.each do |hour|
        p hour.sunday
        @total_hours += hour.sunday if hour.sunday
        @total_hours += hour.monday if hour.monday
        @total_hours += hour.tuesday if hour.tuesday
        @total_hours += hour.wednesday if hour.wednesday
        @total_hours += hour.thursday if hour.thursday
        @total_hours += hour.friday if hour.friday
        @total_hours += hour.saturday if hour.saturday
        puts "Total hours in cycle: #{@total_hours}"
      end
    end
    puts "Total hours after cycle: #{@total_hours}"

  end



end
