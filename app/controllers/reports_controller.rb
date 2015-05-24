class ReportsController < ApplicationController

  before_action :correct_report, only: [:show, :edit, :update, :destroy]
  before_action :correct_week, only: [:index, :show, :update]


  def index
    if $report_id and Report.where("user_id = ? AND id = ?",
                                   current_user.id, Report.find($report_id)).count == 1
      @hours = Hour.where(report_id: $report_id)
      @report = Report.find($report_id)

      @previous = Report.where(["user_id = ? AND id < ?", current_user.id, @report.id]).last
      @next     = Report.where(["user_id = ? AND id > ?", current_user.id, @report.id]).first
      @week_begin = DateTime.parse(Report.find($report_id).created_at.to_s).beginning_of_week(start_day = :sunday).strftime('%m/%d/%Y')
      @week_end   = DateTime.parse(Report.find($report_id).created_at.to_s).end_of_week(start_day = :sunday).strftime('%m/%d/%Y')

      # current week, landing from show method
      render 'index' if Report.where("user_id = ? AND id = ? AND week_id = ? AND timesheet_ready = ?",
                                     current_user.id, Report.find($report_id), @week_id, false).count == 1
      # previous week locked, landing from show method
      # render 'index_locked' if Report.where("user_id = ? AND id = ? AND week_id < ?",
      #                                       current_user.id, Report.find($report_id), @week_id).count >= 1
      render 'index_locked' if Report.where(user_id: current_user.id, id: $report_id, timesheet_ready: true).count >= 1
      $report_id = nil

    elsif $report_id.nil? and Report.last.id and Report.where("user_id = ? AND id = ?",
                                                              current_user.id, Report.last.id).count == 1
      @hours = Hour.where(report_id: Report.last.id)
      @report = Report.find(Report.last.id)

      @previous = Report.where(["user_id = ? AND id < ?", current_user.id, @report.id]).last
      @next     = Report.where(["user_id = ? AND id > ?", current_user.id, @report.id]).first
      @week_begin = DateTime.parse(Report.find(@report.id).created_at.to_s).beginning_of_week(start_day = :sunday).strftime('%m/%d/%Y')
      @week_end   = DateTime.parse(Report.find(@report.id).created_at.to_s).end_of_week(start_day = :sunday).strftime('%m/%d/%Y')

      # current week, landing from restored session
      render 'index' if Report.where("user_id = ? AND id = ? AND week_id = ? AND timesheet_ready = ?",
                                     current_user.id, Report.find(@report.id), @week_id, false).count == 1
      # previous week locked, landing from restored session
      # render 'index_locked' if Report.where("user_id = ? AND id = ? AND week_id < ?",
      #                                       current_user.id, Report.find(@report.id), @week_id).count >= 1
      render 'index_locked' if Report.where(user_id: current_user.id, id: @report.id, timesheet_ready: true).count >= 1


    else
    end
  end

  def show
    @categories = Category.all
    cat_size = @categories.count+1
    n = 0
    @hours = Hour.where(report_id: params[:id])
    until n == cat_size-1
      @hours[n].update_attributes(category_id: @categories[n].id) if @hours[n].category_id == nil
      n+=1
    end
    @report.update_attributes(week_id: @week_id) if @report.week_id == nil

    # save global variable for Previous and Next navigation
    $report_id = params[:id]
    redirect_to reports_path
  end


  def sign
    @report = Report.where(id: params[:id]).first
    @report.update_attributes(signed: true)

    # save global variable for Previous and Next navigation
    $report_id = params[:id]
    redirect_to reports_path
  end


  def search
    # selected time range
    if params[:date_custom] != ""
      @date = Time.strptime(params[:date_custom],"%m/%d/%Y")
      @date_beg = DateTime.parse(@date.to_s).beginning_of_week(start_day = :sunday)
      @date_end = DateTime.parse(@date.to_s).end_of_week(start_day = :sunday)
    else
      flash[:alert] = "No input data has been received!"
      redirect_to :back
    end

    # reports filter
    @reports = Report.where("user_id = ? AND created_at >= ? AND created_at <= ?", current_user.id, @date_beg, @date_end)

    if @reports.count >= 1
      redirect_to "/reports/#{@reports.first.id}"
    else
      flash[:alert] = "No reports has been found for a specific period!"
      redirect_to :back
    end
  end



  def create
    @reports = Report.all
    @report = current_user.reports.build(report_params)
    if @report.save
      flash[:success] = "Report has been successfully created!"
      redirect_to @report
    else
      render 'new'
    end
  end

  def update
    if @report.update_attributes(report_params)
      Hour.where(report_id: params[:id]).where.not(category_id: nil).delete_all
      @categories = Category.all
      cat_size = @categories.count+1
      puts "cat_size: #{cat_size}"
      n = 0
      @hours = Hour.where(report_id: params[:id])
      # raise params.inspect
      until n == cat_size-1
        puts "N: #{n}"
        @hours[n].update_attributes(category_id: @categories[n].id) if @hours[n].category_id == nil
        puts "Updated category: #{@hours[n].category_id}"
        puts "Updated #{@hours[n]}"
        puts "cat_size: #{cat_size}"
        n+=1
      end
      @report.update_attributes(week_id: @week_id) if @report.week_id == nil



      $report_id = params[:id]
      respond_to do |format|
        format.any { redirect_to reports_path, notice: 'Report has been successfully updated!' }
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end


  def export
    @hours = Hour.where(report_id: params[:id])
    if render xlsx: "export", template: "reports/export"
      flash[:notice] = 'Report has been successfully exported!'
    else
      flash[:error] = 'Something goes wrong!'
    end
  end


private

  def report_params
    params.require(:report).permit(:id, :name, :category_id, :user_id, :week_id, hours_attributes:[:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday])
  end


  # Before filters

  def correct_report
    @report = Report.find(params[:id])
  end

  def correct_week
    # %U - Week number of the year. The week starts with Sunday. (00..53)
    # %W - Week number of the year. The week starts with Monday. (00..53)
    @week_id = Date.today.strftime("%U").to_i
  end


end
