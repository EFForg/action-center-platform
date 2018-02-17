class Admin::TopicCategoriesController < Admin::ApplicationController
  def index
    render json: TopicCategory.all
  end

  def create
    topic_category = TopicCategory.new(topic_category_params)

    if topic_category.save
      render json: topic_category
    else
      render json: topic_category.errors, status: 500
    end
  end

  def destroy
    begin
      TopicCategory.destroy(params[:id])
      render json: { id: params[:id] }
    rescue => e
      render text: e.message, status: 500
    end
  end

  def update
    topic_category = TopicCategory.find(params[:id])

    if topic_category.update_attributes(topic_category_params)
      render json: topic_category
    else
      render json: topic_category.errors, status: 500
    end
  end

  private

  def topic_category_params
    params.require(:topic_category).permit(:name)
  end
end
