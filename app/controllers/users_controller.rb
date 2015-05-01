class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @teams = Team.all
  end

  def create
    @user = User.new(user_params)
    @teams = Team.all
    if @user.save
      flash[:success] = "User has been successfully created!"
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
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :team_id, :admin)
  end


end
