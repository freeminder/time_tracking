# frozen_string_literal: true

# Reports controller
class ReportsController < ApplicationController
  before_action :set_report, only: %i[show update sign export]

  def index
    cr = current_user.reports
    path = cr.any? ? report_path(cr.last) : new_report_path
    redirect_to path
  end

  def new
    @report = Report.new(created_at: Time.zone.now, week_id: current_week)
    @report.categories = Category.all
    @total_hours = Date::DAYNAMES.to_h { |weekday| [weekday.downcase, 0] }

    week_begin_and_end(true)
    @previous = current_user.reports.last
  end

  def show
    @hours = @report.hours
                    .joins(:category)
                    .select('hours.*, categories.name as category_name')
    @total_hours = Date::DAYNAMES.to_h { |weekday| [weekday.downcase, 0] }

    @previous = current_user.reports.where(['id < ?', @report.id]).last
    @next     = current_user.reports.where(['id > ?', @report.id]).first
    week_begin_and_end

    render 'locked' if @report.timesheet_locked
  end

  def search
    if params[:date_custom] != ''
      reports = ReportService.search(current_user, params)
      if reports.any?
        redirect_to report_path(reports.first)
      else
        message = 'No reports have been found for a specified period!'
        redirect_back fallback_location: reports_path, alert: message
      end
    else
      redirect_back fallback_location: reports_path, alert: 'No input data has been received!'
    end
  end

  def create
    cw = current_week
    @report = current_user.reports.build(report_params.merge(week_id: cw))
    if @report.save
      message = 'Report has been successfully created!'
      redirect_to report_path(@report), notice: message
    else
      render 'new'
    end
  end

  def update
    if @report.update(report_params)
      @report.update(signed: true) if @report.signed == false
      if params[:commit] == 'Export'
        week_begin_and_end
        render xlsx: 'export', template: 'exports/timesheet'
      else
        message = 'Report has been successfully updated!'
        redirect_to report_path(@report), notice: message
      end
    else
      render action: 'show'
    end
  end

  def sign
    if @report.update(signed: true)
      message = 'Report has been successfully signed!'
      redirect_to report_path(@report), notice: message
    else
      render action: 'show'
    end
  end

  def export
    week_begin_and_end
    render xlsx: 'export', template: 'exports/timesheet'
  end

  private

  def report_params
    params.require(:report)
          .permit(:id, :user_id, :week_id, hours_attributes:
            %i[id category_id sunday monday tuesday wednesday
               thursday friday saturday])
  end

  def set_report
    @report = Report.find(params[:id])
    return if @report.user == current_user || current_user.admin

    flash[:alert] = 'Access denied!'
    redirect_to reports_path
  end

  def week_begin_and_end(today = nil)
    that = @report.created_at
    d = today ? Time.zone.today : Date.new(that.year, that.month, that.day)
    @week_begin = d.beginning_of_week(:sunday).strftime('%m/%d/%Y')
    @week_end   = d.end_of_week(:sunday).strftime('%m/%d/%Y')
  end

  def current_week
    # %U - Week number of the year. The week starts with Sunday. (00..53)
    # %W - Week number of the year. The week starts with Monday. (00..53)
    Time.zone.today.strftime('%U').to_i
  end
end
