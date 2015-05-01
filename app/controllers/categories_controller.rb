class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @categories = Category.all
    if @category.save
      flash[:success] = "Category has been successfully created!"
      redirect_to @category
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      respond_to do |format|
        format.any { redirect_to :back, notice: 'Category has been successfully updated!' }
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      respond_to do |format|
        format.any { redirect_to action: 'index' }
        flash[:notice] = 'Category has been successfully deleted!'
      end
    else
      respond_to do |format|
        format.any { render action: 'edit' }
      end
    end
  end

private

  def category_params
    params.require(:category).permit(:name)
  end


end
