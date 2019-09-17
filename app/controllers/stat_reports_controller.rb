class StatReportsController < ApplicationController
  before_filter :authorize_admin
  before_action :set_date, except: [:get_user_hours]
  before_action :set_preload, except: [:get_user_hours, :set_date]

  def user
    @user = User.find(params[:user_id])
    @categories = get_user_hours(@user, categories_all: @categories_all, reports: @reports, hours: @hours)[:categories]
  end

  def team
    @team = Team.find(params[:team_id])
    @users = @team.users.map { |user| get_user_hours(user, categories_all: @categories_all, reports: @reports, hours: @hours) }
  end

  def category
    @category = Category.find(params[:category_id])
    @users = User.all.map { |user| get_user_hours(user, single_category: @category, reports: @reports, hours: @hours) }
  end

  def all
    @users = User.all.map { |user| get_user_hours(user, categories_all: @categories_all, reports: @reports, hours: @hours) }
  end


  private

  def get_user_hours(user, opts = {})
    user_reports = opts[:reports].select { |report| report.user_id == user.id }
    categories = {}
    opts[:categories_all] = [opts[:single_category]] if opts[:single_category]
    opts[:categories_all].each do |category|
      hours = opts[:hours].select do |hour|
        hour.category_id == category.id && user_reports.map { |report| report.id }.include?(hour.report_id)
      end
      # precise hours calculation by days from the first week
      hffw = hours.select { |hour| hour.created_at.strftime("%U").to_i == @date.strftime("%U").to_i } # hours for first week
      fwh = hffw.map { |hour| hour.attributes.except("id", "report_id", "category_id", "created_at").to_a[@date.wday,6].to_h.values.compact.sum }.sum
      owh = (hours - hffw).map { |hour| hour.attributes.except("id", "report_id", "category_id", "created_at").values.compact.sum }.sum
      categories.merge!(category.name => fwh + owh) # first week hours + other weeks hours
    end
    { user_full_name: user.full_name, user_rate: user.rate, categories: categories }
  end

  def set_date
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
  end

  def set_preload
    @categories_all = Category.all
    @reports = Report.where("created_at >= :created_at", created_at: @date)
    @hours = Hour.where("created_at >= :created_at", created_at: @date)
  end
end
