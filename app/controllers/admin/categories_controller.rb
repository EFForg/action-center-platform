class Admin::CategoriesController < Admin::ApplicationController
  def index
    @categories = Category.all
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:title))

    if @category.save
      flash[:message] = %(Category "#{@category.title}" created)
      redirect_to admin_categories_path
    else
      flash[:error] = "Couldn't create category. Please try again."
      render "index"
    end
  end
end
