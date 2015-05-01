class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    white_params = [:email, :first_name, :last_name, :team, :admin]
    if @user.update_attributes(params.permit(white_params))
      respond_to do |format|
        format.any { redirect_to :back, notice: 'Success' }
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
        flash[:notice] = 'Success'
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end

end
