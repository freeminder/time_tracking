# frozen_string_literal: true

# StatsReports controller
class StatReportsController < ApplicationController
  before_action :authorize_admin
  before_action :set_date
  before_action :set_preload, except: [:set_date]

  def user
    @user = User.find(params[:user_id])
    @categories = StatService.new(@user, preloaded_data: @preloaded_data)
                             .user_hours[:categories]
  end

  def team
    @team = Team.find(params[:team_id])
    @users = @team.users.map do |user|
      StatService.new(user, preloaded_data: @preloaded_data).user_hours
    end
  end

  def category
    @category = Category.find(params[:category_id])
    @users = User.all.map do |user|
      StatService.new(
        user, preloaded_data: @preloaded_data.merge(single_category: @category)
      ).user_hours
    end
  end

  def all
    @users = User.all.map do |user|
      StatService.new(user, preloaded_data: @preloaded_data).user_hours
    end
  end

  private

  def set_date
    @date = (date_custom || date) || 1.second.ago
  end

  def date_custom
    return if params[:date_custom].blank?

    Time.strptime(params[:date_custom], '%m/%d/%Y')
  end

  def date
    dates_hash = {
      last_week: 1.week.ago,
      last_month: 1.month.ago,
      last_year: 1.year.ago
    }

    return if params[:date].blank?

    dates_hash.find { |k, _| k == params[:date].to_sym }.last
  end

  def set_preload
    @preloaded_data = {
      categories_all: Category.all,
      reports: Report.where('created_at >= :created_at', created_at: @date),
      hours: Hour.where('created_at >= :created_at', created_at: @date),
      date: @date
    }
  end
end
