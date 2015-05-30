class Admin::TopicCategoriesController < Admin::ApplicationController
  def index
    @topic_categories = TopicCategory.all
    render json: @topic_categories
  end

  def create
    @topic_category = TopicCategory.new
    new_attributes = {}
    @topic_category.attribute_names.each{|key| new_attributes[key] = params[key]  unless params[key].nil? }    
    @topic_category.attributes = new_attributes

    if @topic_category.save
      render :json => @topic_category
    else
      render :json => @topic_category.errors, :status => 500
    end    
  end

  def destroy
    begin
      TopicCategory.destroy(params[:id])
      render json: {id: params[:id]}
    rescue => e
      render text: e.message, status: 500
    end
  end

  def update
    @topic_category = TopicCategory.find params[:id]
    params.delete :id

    new_attributes = {}
    @topic_category.attribute_names.each{|key| new_attributes[key] = params[key] if !params[key].nil? }

    if @topic_category.update_attributes(new_attributes)
      render :json => @topic_category
    else
      render :json => @topic_category.errors, :status => 500
    end
  end
 

end
