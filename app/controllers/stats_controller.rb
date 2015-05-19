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
    elsif params[:id] == 'team_category'
      render 'team_category'
    elsif params[:id] == 'team'
      render 'team'
    elsif params[:id] == 'category'
      render 'category'
    elsif params[:id] == 'all'
      render 'all'
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

    # reports filter for a single user
    if params[:user_id]
      @stats = Report.where("user_id = ? AND created_at >= ?", params[:user_id], @date)
      @hours = Array.new
      @stats.to_a.each do |report|
        puts "pushing #{report.inspect}"
        @hours.push(Hour.where(report_id: report.id))
        puts "pushed #{report.id}"
      end

      @cat_size = Category.count
      @total_hours = 0

      @tsumtcat = Array.new(@cat_size) { |i| i = 0 }
      @hours.each do |report|
        puts "REPORT : #{report.to_a}"
        n = 0
        @sumtcat = Array.new(@cat_size) { |i| i = 0 }
        until n == @cat_size
          @tcat = 0
          @cat = Array.new(@cat_size) { |i| i = 0 }
          @cat[n] += report[n].sunday if report[n].sunday
          @cat[n] += report[n].monday if report[n].monday
          @cat[n] += report[n].tuesday if report[n].tuesday
          @cat[n] += report[n].wednesday if report[n].wednesday
          @cat[n] += report[n].thursday if report[n].thursday
          @cat[n] += report[n].friday if report[n].friday
          @cat[n] += report[n].saturday if report[n].saturday
          @cat.each {|i| @tcat += i }
          @sumtcat[n] += @tcat
          n += 1
          puts "TOTAL for CATEGORY #{n}: #{@tcat}"
        end
        puts "SUM TOTAL for REPORT: #{@sumtcat}"

        n = 0
        until n == @cat_size
          @tsumtcat[n] += @sumtcat[n]
          n += 1
        end
        puts "TOTAL SUM OF ALL REPORTS: #{@tsumtcat}"
      end
      @date = @date_custom if @date_custom
      @reports = Report.where("user_id = ? AND created_at >= ?", params[:user_id], @date)
      @hours = Array.new
      @reports.each do |report|
        @hours.push(Hour.where(report_id: report.id))
      end


    # reports filter for a team
    elsif params[:team_id]
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
    # reports filter for a team with category
    elsif params[:team_category_id] or params[:category_team_id]
      @team_users = User.where("team_id = ?", params[:team_category_id])
      @stats = Array.new
      @team_users.each do |user|
        @stats.push(Report.where("user_id = ? AND created_at >= ?", user.id, @date))
      end
      @hours = Array.new
      @stats.to_a.each do |report|
        report.each do |rr|
          puts "pushing #{rr.inspect}"
          @hours.push(Hour.where("report_id = ? AND category_id = ?", rr.id, params[:category_team_id]))
          puts "pushed #{rr.id}"
        end
      end
    # reports filter for a single category
    elsif params[:category_id]
      @category_hours = Hour.where("category_id = ?", params[:category_id])
      @stats = Array.new
      @category_hours.each do |c_hour|
        @stats.push(Report.where("id = ? AND created_at >= ?", c_hour.report_id, @date))
      end
      @hours = Array.new
      @stats.each do |report|
        puts "pushing to hours #{report.to_a}"
        report.each do |rr|
          puts "pushing #{rr.inspect}"
          @hours.push(Hour.where("report_id = ? AND category_id = ?", rr.id, params[:category_id]))
          puts "pushed #{rr.id}"
        end
      end
    # reports filter for multiple categories, users and teams (all)
    else
      @category_hours = Hour.all
      @stats = Array.new
      @category_hours.each do |c_hour|
        @stats.push(Report.where("id = ? AND created_at >= ?", c_hour.report_id, @date))
      end
      @hours = Array.new
      @stats.each do |report|
        puts "pushing to hours #{report.to_a}"
        report.each do |rr|
          puts "pushing #{rr.inspect}"
          @hours.push(Hour.where(report_id: rr.id))
          puts "pushed #{rr.id}"
        end
      end
    end

    # time calculation
    @total_hours = 0

    @hours.each do |report|
      puts "REPORT : #{report.to_a}"
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
