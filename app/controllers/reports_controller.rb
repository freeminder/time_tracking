class ReportsController < ApplicationController

  # respond_to :html, :xlsx, :json
  before_action :correct_report, only: [:show, :edit, :update, :destroy]


  def index
    if Report.last.id != nil and Report.where("user_id = ? AND id = ?", current_user.id, Report.last.id).count == 1
      @hours = Hour.where(report_id: Report.last.id)
      @report = Report.find(Report.last.id)

      render 'index_last'
    else
      @hours = Hour.all
      @categories = Category.all
      @report = Report.new

      @report.categories = @categories.map { |x| Category.new name: x.name }
      @report.categories.build
      @report.hours.build
      render 'index'
    end
  end

  def show
    @categories = Category.all
    @hours = Hour.where(report_id: params[:id])
    n = 0
    @hours.each do |hour|
      hour.update_attributes(category_id: @categories[n].id)
      n+=1
    end
    redirect_to reports_path
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
    # respond_to do |format|
    #   format.xlsx
    # end
      flash[:notice] = 'Report has been successfully exported!'
    else
      flash[:error] = 'Something goes wrong!'
    end
    # render 'index_last'
  end

private

  def report_params
    params.require(:report).permit(:id, :name, :category_id, :user_id, hours_attributes:[:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday])
  end


  # Before filters

  def correct_report
    @report = Report.find(params[:id])
  end


end
