class Admin::TopicSetsController < Admin::ApplicationController
  def index
    topic_sets = TopicSet.all.order(:tier)
    render json: topic_sets
  end

  def destroy
    begin
      TopicSet.destroy(params[:id])
      render json: { id: params[:id] }
    rescue => e
      render text: e.message, status: 500
    end
  end

  def create
    topic_category = TopicCategory.find(params.require(:topic_set).delete(:topic_category_id))
    tier = topic_category.topic_sets.map(&:tier).append(0).max + 1
    topic_set = topic_category.topic_sets.build(tier: tier)

    if topic_set.save
      render json: topic_set
    else
      render json: topic_set.errors, status: 500
    end
  end

  def update
    topic_set = TopicSet.find(params[:id])

    if topic_set.update_attributes(topic_set_params)
      render json: topic_set
    else
      render json: topic_set.errors, status: 500
    end
  end

  private

  def topic_set_params
    params.require(:topic_set).permit(:tier)
  end
end
