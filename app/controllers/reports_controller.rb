class ReportsController < ApplicationController

  before_action :correct_report, only: [:show, :edit, :update, :destroy]


  def index
    @reports = Report.all
    @users = User.all
    @categories = Category.all

    @days = Array.new
    @total = Hash[
      "hours" => 0,
      "Monday_hours" => 0,
      "Tuesday_hours" => 0,
      "Wednesday_hours" => 0,
      "Thursday_hours" => 0,
      "Friday_hours" => 0,
      "Saturday_hours" => 0,
      "Sunday_hours" => 0
    ]
  end

  def show
    @users = User.all
    @category_id = @report.categories_id
    @category = Category.find(@category_id)
  end

  def new
    @report = Report.new
    @categories = Category.all
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

  def edit
    @categories = Category.all
  end

  def update
    if @report.update_attributes(report_params)
      respond_to do |format|
        format.any { redirect_to :back, notice: 'Report has been successfully updated!' }
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end

  def destroy
    if @report.destroy
      respond_to do |format|
        format.any { redirect_to action: 'index' }
        flash[:notice] = 'Report has been successfully deleted!'
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end

private

  def report_params
    params.require(:report).permit(:name, :day, :hours, :categories_id, :user_id)
  end

  # Before filters

  def correct_report
    @report = Report.find(params[:id])
  end


end
