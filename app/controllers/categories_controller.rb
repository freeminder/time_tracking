class CategoriesController < ApplicationController
  before_filter :authorize_admin
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      CategoryService.add_to_reports(@category.id)
      redirect_to @category, notice: "Category has been successfully created!"
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to :back, notice: "Category has been successfully updated!"
    else
      render action: "edit"
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, notice: "Category has been successfully deleted!"
    else
      render action: "edit"
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
