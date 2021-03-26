class Admin::TopicsController < Admin::ApplicationController
  layout "admin"

  def destroy
    Topic.destroy(params[:id])
    render json: { id: params[:id] }
  rescue StandardError => e
    render body: e.message, status: 500
  end

  def create
    topic_set = TopicSet.find(params.require(:topic).delete(:topic_set_id))
    topic = topic_set.topics.build(topic_params)

    if topic.save
      render json: topic
    else
      render json: topic.errors, status: 500
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name)
  end
end
