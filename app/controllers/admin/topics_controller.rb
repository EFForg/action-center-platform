class Admin::TopicsController < Admin::ApplicationController
  layout "admin"

  def index
  end

  def destroy
    begin
      Topic.destroy(params[:id])
      render json: {id: params[:id]}
    rescue => e
      render text: e.message, status: 500
    end
  end

  def create
    @topic = Topic.new
    new_attributes = {}
    @topic.attribute_names.each{|key| new_attributes[key] = params[key]  unless params[key].nil? }    
    @topic.attributes = new_attributes
    if @topic.save
      render :json => @topic
    else
      render :json => @topic.errors, :status => 500
    end    
  end
end
