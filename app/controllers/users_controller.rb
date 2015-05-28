class UsersController < ApplicationController

  before_filter :authorize_admin, except: [:show]


  def index
    @users = User.all
  end

  def show
    if current_user.admin?
      @user = User.find(params[:id])
    else
      if current_user.id == params[:id].to_i
        @user = User.find(params[:id])
      else
        redirect_to root_path, alert: 'Access Denied'
      end
    end
  end

  def new
    @user = User.new
    @teams = Team.all
  end

  def create
    @user = User.new(user_params)
    @teams = Team.all
    if @user.save
      # create empty report for the new user
      current_week = Date.today.strftime("%U").to_i
      @report = Report.create(user_id: @user.id, week_id: current_week)
      Category.all.each do |category|
        Hour.create(category_id: category.id, report_id: @report.id)
      end
      # show success popup
      flash[:success] = "User has been successfully created!"
      # redirect and show user's profile
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @teams = Team.all
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      respond_to do |format|
        format.any { redirect_to :back, notice: 'User has been successfully updated!' }
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      respond_to do |format|
        format.any { redirect_to action: 'index' }
        flash[:notice] = 'User has been successfully deleted!'
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :team_id, :rate, :admin)
  end


end
