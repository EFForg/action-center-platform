class Admin::TopicSetsController < Admin::ApplicationController
  def index
    @topic_sets = TopicSet.all.order(:tier)
    render json: @topic_sets
  end

  def destroy
    begin
      TopicSet.destroy(params[:id])
      render json: {id: params[:id]}
    rescue => e
      render text: e.message, status: 500
    end
  end

  def create
    @topic_set = TopicSet.new
    new_attributes = {}
    @topic_set.attribute_names.each{|key| new_attributes[key] = params[key]  unless params[key].nil? }    
    @topic_set.attributes = new_attributes
    @topic_set.tier = TopicSet.where(topic_category_id: params[:topic_category_id]).map {|t| t.tier}.append(0).max + 1 unless params[:topic_category_id].nil? or new_attributes.include? "tier"

    if @topic_set.save
      render :json => @topic_set
    else
      render :json => @topic_set.errors, :status => 500
    end    
  end

  def update
    @topic_set = TopicSet.find params[:id]
    params.delete :id

    new_attributes = {}
    @topic_set.attribute_names.each{|key| new_attributes[key] = params[key] if !params[key].nil? }

    if @topic_set.update_attributes(new_attributes)
      render :json => @topic_set
    else
      render :json => @topic_set.errors, :status => 500
    end
  end
 

end
