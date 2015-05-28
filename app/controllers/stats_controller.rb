class StatsController < ApplicationController
  before_filter :authorize_admin

  def index
  end

  # def export
  #   if render xlsx: "export", template: "stats/export"
  #     flash[:notice] = 'Report has been successfully exported!'
  #   else
  #     flash[:error] = 'Something goes wrong!'
  #   end
  # end


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
    elsif params[:id] == 'team'
      render 'team'
    elsif params[:id] == 'category'
      render 'category'
    elsif params[:id] == 'all'
      render 'all'
    elsif params[:id] == 'export_user'
      render xlsx: "export", template: "stats/export_user"
    elsif params[:id] == 'export_team'
      render xlsx: "export", template: "stats/export_team"
    elsif params[:id] == 'export_category'
      render xlsx: "export", template: "stats/export_category"
    elsif params[:id] == 'export_all'
      render xlsx: "export", template: "stats/export_all"
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
    @stats = Report.where("user_id = ? AND created_at >= ?", params[:user_id], @date)
    if params[:user_id] && @stats.any?
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
      # generate array with hashes for stats views
      # [0 => {user_id => 1, categories => [0 => {name => "Production", hours => 19}, 1 => {name => "Documentation", hours => 17}]},
      #  1 => {user_id => 2, categories => [0 => {name => "Production", hours => 9}, 1 => {name => "Documentation", hours => 7}]}]
      users_arr = Array.new
      team_users = User.where(team_id: params[:team_id])
      team_users.each do |user|
        # find all user's reports
        @stats = Report.where("user_id = ? AND created_at >= ?", user.id, @date)
        @hours = Array.new
        @stats.to_a.each do |report|
          # push all user's hours to array from reports
          @hours.push(Hour.where(report_id: report.id))
        end
        # calculate hours in categories
        @cat_size = Category.count
        @tsumtcat = Array.new(@cat_size) { |i| i = 0 }
        @hours.each do |report|
          n = 0
          until n == @cat_size
            # calculate total for the category
            tcat = 0
            tcat += report[n].sunday if report[n].sunday
            tcat += report[n].monday if report[n].monday
            tcat += report[n].tuesday if report[n].tuesday
            tcat += report[n].wednesday if report[n].wednesday
            tcat += report[n].thursday if report[n].thursday
            tcat += report[n].friday if report[n].friday
            tcat += report[n].saturday if report[n].saturday
            @tsumtcat[n] += tcat
            n += 1
          end
        end

        # push hash with categories' names and hours to array
        n = 0
        categories = Array.new
        Category.all.each do |category|
          categories.push(Hash[name: category.name, hours: @tsumtcat[n]])
          n += 1
        end
        # push hash with user_ids and categories' names&hours to array
        users_arr.push(Hash[user_id: user.id, categories: categories])
        puts "===== PUSHED #{Hash[user_id: user.id, categories: categories]} ====="
      end
      puts "===== USERS ARRAY #{users_arr} ====="

      # set global variable for stats views and export template
      $users_arr = users_arr
      # create empty @hours for time calculation
      @hours = Array.new


    # reports filter for a single category
    elsif params[:category_id]
      # find hours by category_id
      @category_hours = Hour.where(category_id: params[:category_id])
      # extract reports_ids from hours
      @reports = Array.new
      @category_hours.each do |hour|
        @reports.push(hour.report_id)
      end
      # extract users_ids from reports
      @users_ids = Array.new
      @reports.uniq.each do |report_id|
        @users_ids.push(Report.find(report_id).user_id)
      end

      # generate array with hashes for stats views
      # [0 => {user_id => 19, hours => 25}, 1 => {user_id => 20, hours => 17},
      #  2 => {user_id => 21, hours => 9}, 3 => {user_id => 22, hours => 7}]
      users_arr = Array.new
      @users_ids.uniq.each do |user_id|
        # find all user's reports
        @stats = Report.where("user_id = ? AND created_at >= ?", user_id, @date)
        puts @stats.to_a
        @hours = Array.new
        @stats.to_a.each do |report|
          # push all user's hours to array from reports
          @hours.push(Hour.where(report_id: report.id))
        end
        # calculate hours in categories
        @cat_size = Category.count
        @tsumtcat = 0
        # push hours where category_id = Category.find(params[:category_id]).id
        @hours.each do |report|
          report.each do |hour|
            # calculate total for the category
            tcat = 0
            tcat += hour.sunday if hour.sunday and hour.category_id == Category.find(params[:category_id]).id
            tcat += hour.monday if hour.monday and hour.category_id == Category.find(params[:category_id]).id
            tcat += hour.tuesday if hour.tuesday and hour.category_id == Category.find(params[:category_id]).id
            tcat += hour.wednesday if hour.wednesday and hour.category_id == Category.find(params[:category_id]).id
            tcat += hour.thursday if hour.thursday and hour.category_id == Category.find(params[:category_id]).id
            tcat += hour.friday if hour.friday and hour.category_id == Category.find(params[:category_id]).id
            tcat += hour.saturday if hour.saturday and hour.category_id == Category.find(params[:category_id]).id
            @tsumtcat += tcat
            puts "===== CATEGORY SUMMARY: #{tcat} ====="
          end
        end

        # push hash with user_ids and categorie's hours to array
        users_arr.push(Hash[user_id: user_id, hours: @tsumtcat])
        puts "===== PUSHED #{Hash[user_id: user_id, hours: @tsumtcat]} ====="
      end
      puts "===== USERS ARRAY #{users_arr} ====="

      # set global variable for stats views and export template
      $users_arr = users_arr
      # create empty @hours for time calculation
      @hours = Array.new


    # reports filter for multiple categories, users and teams (all)
    elsif params[:all]
      # generate array with hashes for stats views
      # [0 => {user_id => 1, categories => [0 => {name => "Production", hours => 19}, 1 => {name => "Documentation", hours => 17}]},
      #  1 => {user_id => 2, categories => [0 => {name => "Production", hours => 9}, 1 => {name => "Documentation", hours => 7}]}]
      users_arr = Array.new
      User.all.each do |user|
        # find all user's reports
        @stats = Report.where("user_id = ? AND created_at >= ?", user.id, @date)
        @hours = Array.new
        @stats.to_a.each do |report|
          # push all user's hours to array from reports
          @hours.push(Hour.where(report_id: report.id))
        end
        # calculate hours in categories
        @cat_size = Category.count
        @tsumtcat = Array.new(@cat_size) { |i| i = 0 }
        @hours.each do |report|
          n = 0
          until n == @cat_size
            # calculate total for the category
            tcat = 0
            tcat += report[n].sunday if report[n].sunday
            tcat += report[n].monday if report[n].monday
            tcat += report[n].tuesday if report[n].tuesday
            tcat += report[n].wednesday if report[n].wednesday
            tcat += report[n].thursday if report[n].thursday
            tcat += report[n].friday if report[n].friday
            tcat += report[n].saturday if report[n].saturday
            @tsumtcat[n] += tcat
            n += 1
          end
        end

        # push hash with categories' names and hours to array
        n = 0
        categories = Array.new
        Category.all.each do |category|
          categories.push(Hash[name: category.name, hours: @tsumtcat[n]])
          n += 1
        end
        # push hash with user_ids and categories' names&hours to array
        users_arr.push(Hash[user_id: user.id, categories: categories])
        puts "===== PUSHED #{Hash[user_id: user.id, categories: categories]} ====="
      end
      puts "===== USERS ARRAY #{users_arr} ====="

      # set global variable for stats views and export template
      $users_arr = users_arr
      # create empty @hours for time calculation
      @hours = Array.new


    else
      render text: "No stats available."
    end

    # time calculation
    return if @hours.nil?
    @total_hours = 0
    @hours.each do |report|
      # puts "REPORT : #{report.to_a}"
      report.each do |hour|
        @total_hours += hour.sunday if hour.sunday
        @total_hours += hour.monday if hour.monday
        @total_hours += hour.tuesday if hour.tuesday
        @total_hours += hour.wednesday if hour.wednesday
        @total_hours += hour.thursday if hour.thursday
        @total_hours += hour.friday if hour.friday
        @total_hours += hour.saturday if hour.saturday
        # puts "Total hours in cycle: #{@total_hours}"
      end
    end
    puts "Total hours after cycle: #{@total_hours}"
  end
end
