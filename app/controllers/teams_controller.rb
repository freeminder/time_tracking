# frozen_string_literal: true

# Teams controller
class TeamsController < ApplicationController
  before_filter :authorize_admin
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
  end

  def show; end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to @team, notice: 'Team has been successfully created!'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @team.update_attributes(team_params)
      redirect_to :back, notice: 'Team has been successfully updated!'
    else
      render action: 'edit'
    end
  end

  def destroy
    if @team.destroy
      redirect_to teams_path, notice: 'Team has been successfully deleted!'
    else
      render action: 'edit'
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
