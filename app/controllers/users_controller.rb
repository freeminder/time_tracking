# frozen_string_literal: true

# Users controller
class UsersController < ApplicationController
  before_action :authorize_admin, except: :show
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.all
  end

  def show
    if params[:id].to_i == current_user.id || current_user.admin
      @user = User.find(params[:id])
    else
      redirect_to root_path, alert: 'Access denied!'
    end
  end

  def new
    @user = User.new
    @teams = Team.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      CreateNewTimesheetsWorker.perform_async(@user.id)
      redirect_to @user, notice: 'User has been successfully created!'
    else
      render 'new'
    end
  end

  def edit
    @teams = Team.all
  end

  def update
    if @user.update(user_params)
      redirect_back fallback_location: users_path, notice: 'User has been successfully updated!'
    else
      render action: 'edit'
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: 'User has been successfully deleted!'
    else
      render action: 'edit'
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:email, :password, :password_confirmation,
                  :first_name, :last_name, :team_id, :rate, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
