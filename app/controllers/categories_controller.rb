# frozen_string_literal: true

# Categories controller
class CategoriesController < ApplicationController
  before_filter :authorize_admin
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.all
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      AddCategoryToReportsWorker.perform_async(@category.id)
      message = 'Category has been successfully created!'
      redirect_to @category, notice: message
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @category.update_attributes(category_params)
      message = 'Category has been successfully updated!'
      redirect_to :back, notice: message
    else
      render action: 'edit'
    end
  end

  def destroy
    if @category.destroy
      message = 'Category has been successfully deleted!'
      redirect_to categories_path, notice: message
    else
      render action: 'edit'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
