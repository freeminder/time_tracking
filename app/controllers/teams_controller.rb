class TeamsController < ApplicationController

  def index
    @teams = Team.all
    @users = User.all
  end

  def show
    @users = User.all
    @team_id = params[:id].to_i
    @current_team = Team.find(@team_id)
  end

end
