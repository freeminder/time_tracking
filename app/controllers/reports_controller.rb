class ReportsController < ApplicationController
  before_action :set_report,   only: [:show, :update, :destroy, :sign, :export]
  before_action :current_week, only: [:new, :update, :create]

  def index
    path = current_user.reports.any? ? report_path(current_user.reports.last) : new_report_path
    redirect_to path
  end

  def new
    @report = Report.new(created_at: Time.now, week_id: @week_id)
    @report.categories = Category.all
    @report.categories.build
    @total_hours = Date::DAYNAMES.map {|weekday| [weekday.downcase, 0]}.to_h

    set_week_begin_and_end(today = true)
    set_nav(search_by_week = true)
  end

  def show
    @hours = @report.hours.order("categories.name").joins(:category).select("hours.*, categories.name as category_name")
    @total_hours = Date::DAYNAMES.map {|weekday| [weekday.downcase, 0]}.to_h

    set_nav
    set_week_begin_and_end

    render "locked" if @report.timesheet_locked
  end

  def search
    if params[:date_custom] != ""
      date = Time.strptime(params[:date_custom],"%m/%d/%Y")
      date_beg = DateTime.parse(date.to_s).beginning_of_week(start_day = :sunday)
      date_end = DateTime.parse(date.to_s).end_of_week(start_day = :sunday)
      reports = Report.where("user_id = ? AND created_at >= ? AND created_at <= ?", current_user.id, date_beg, date_end)
      if reports.any?
        redirect_to report_path(reports.first)
      else
        flash[:alert] = "No reports has been found for a specific period!"
        redirect_to :back
      end
    else
      flash[:alert] = "No input data has been received!"
      redirect_to :back
    end
  end

  def create
    @report = current_user.reports.build(report_params.merge(week_id: @week_id))
    if @report.save
      redirect_to report_path(@report), notice: "Report has been successfully created!"
    else
      render 'new'
    end
  end

  def update
    if @report.update_attributes(report_params)
      @report.update_attributes(signed: true) if @report.signed == false
      redirect_to report_path(@report), notice: 'Report has been successfully updated!'
    else
      render action: 'show'
    end
  end

  def sign
    if @report.update_attributes(signed: true)
      redirect_to report_path(@report), notice: 'Report has been successfully signed!'
    else
      render action: 'show'
    end
  end

  def export
    @user  = @report.user
    @hours = @report.hours
    set_week_begin_and_end
    render xlsx: "export", template: "exports/timesheet"
  end


private
  def report_params
    params.require(:report).permit(:id, :user_id, :week_id, hours_attributes:[:id, :category_id, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday])
  end

  def current_week
    # %U - Week number of the year. The week starts with Sunday. (00..53)
    # %W - Week number of the year. The week starts with Monday. (00..53)
    @week_id = Date.today.strftime("%U").to_i
  end

  def set_report
    @report = Report.find(params[:id])
    unless @report.user == current_user || current_user.admin
      flash[:alert] = "Access denied!"
      redirect_to reports_path
    end
  end

  def set_week_begin_and_end(today = nil)
    if today
      @week_begin = Date.today.beginning_of_week(start_day = :sunday).strftime('%m/%d/%Y')
      @week_end   = Date.today.end_of_week(start_day = :sunday).strftime('%m/%d/%Y')
    else
      @week_begin = Date.commercial(@report.created_at.strftime("%Y").to_i, @report.week_id, 7).strftime("%m/%d/%Y")
      @week_end = Date.commercial(@report.created_at.strftime("%Y").to_i, @report.week_id+1, 6).strftime("%m/%d/%Y")
    end
  end

  def set_nav(search_by_week = nil)
    if search_by_week
      @previous = Report.where(["user_id = ? AND week_id < ?", current_user.id, @week_id]).last
    else
      @previous = Report.where(["user_id = ? AND id < ?", current_user.id, @report.id]).last
      @next     = Report.where(["user_id = ? AND id > ?", current_user.id, @report.id]).first
    end
  end
end
