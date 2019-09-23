class StatReportsController < ApplicationController
  before_filter :authorize_admin
  before_action :set_date
  before_action :set_preload, except: [:set_date]

  def user
    @user = User.find(params[:user_id])
    @categories = StatService.get_user_hours(@user, preloaded_data: @preloaded_data)[:categories]
  end

  def team
    @team = Team.find(params[:team_id])
    @users = @team.users.map { |user| StatService.get_user_hours(user, preloaded_data: @preloaded_data) }
  end

  def category
    @category = Category.find(params[:category_id])
    @users = User.all.map { |user| StatService.get_user_hours(user, preloaded_data: @preloaded_data.merge(single_category: @category)) }
  end

  def all
    @users = User.all.map { |user| StatService.get_user_hours(user, preloaded_data: @preloaded_data) }
  end


  private

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
    @preloaded_data = {
      categories_all: Category.all,
      reports: Report.where("created_at >= :created_at", created_at: @date),
      hours: Hour.where("created_at >= :created_at", created_at: @date),
      date: @date,
    }
  end
end
