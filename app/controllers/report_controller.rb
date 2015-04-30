class ReportController < ApplicationController

  def index
    @users = User.all
    @categories = Category.all
    @reports = Report.all
  end

  def show
    @users = User.all
    @categories = Category.all
    @reports = Report.all
  end

end
