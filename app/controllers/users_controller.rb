class UsersController < ApplicationController
  before_filter :authorize_admin, except: [:show]
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    unless params[:id].to_i == current_user.id || current_user.admin
      redirect_to root_path, alert: "Access denied!"
    else
      @user = User.find(params[:id])
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
      redirect_to @user, notice: "User has been successfully created!"
    else
      render "new"
    end
  end

  def edit
    @teams = Team.all
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to :back, notice: "User has been successfully updated!"
    else
      render action: "edit"
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "User has been successfully deleted!"
    else
      render action: "edit"
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :team_id, :rate, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
