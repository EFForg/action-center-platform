
class CongressController < ApplicationController
  def index
    render json: CongressMember.bioguide_map
  end

  def search
    render json: CongressMember.filter(params[:query]).order(:last_name, :first_name)
  end
end
