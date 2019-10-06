# frozen_string_literal: true

# Stats controller
class StatsController < ApplicationController
  before_filter :authorize_admin
  before_action :set_stat, except: [:index]

  def index;    end

  def user;     end

  def team;     end

  def category; end

  def all;      end

  private

  def set_stat
    @users      = User.all
    @teams      = Team.all
    @categories = Category.all
  end
end
