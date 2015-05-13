class StatsController < ApplicationController

  before_filter :authorize_admin


  def index
  end


  def show
    @categories = Category.all
    @teams = Team.all

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
    if params[:date] == "last_week"
      @date = 1.weeks.ago
    elsif params[:date] == "last_month"
      @date = 1.months.ago
    elsif params[:date] == "last_year"
      @date = 1.years.ago
    else
      @date = 1.seconds.ago
    end

    # reports filter
    @stats = Report.where("user_id = ? AND created_at >= ?", params[:user_id], @date) if params[:user_id]
    # @stats = Report.where("team_id = ? AND created_at >= ?", params[:team_id], @date) if params[:team_id]
    @hours = Array.new
    @stats.to_a.each do |report|
      @hours.push(Hour.where(report_id: report.id))
      puts "pushed #{report.id}"
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

#   def new
#     @stat = Stat.new
#   end

#   def create
#     @stat = Stat.new(stat_params)
#     @stats = Stat.all
#     if @stat.save
#       flash[:success] = "Stat has been successfully created!"
#       redirect_to @stat
#     else
#       render 'new'
#     end
#   end

#   def edit
#     @stat = Stat.find(params[:id])
#   end

#   def update
#     @stat = Stat.find(params[:id])
#     if @stat.update_attributes(stat_params)
#       respond_to do |format|
#         format.any { redirect_to :back, notice: 'Stat has been successfully updated!' }
#       end
#     else
#       respond_to do |format|
#         format.any { render action: 'edit' }
#       end
#     end
#   end

#   def destroy
#     @stat = Stat.find(params[:id])
#     if @stat.destroy
#       respond_to do |format|
#         format.any { redirect_to action: 'index' }
#         flash[:notice] = 'Stat has been successfully deleted!'
#       end
#     else
#       respond_to do |format|
#         format.any { render action: 'edit' }
#       end
#     end
#   end

# private

#   def stat_params
#     params.require(:stat).permit(:name)
#   end


end
