
class CongressController < ApplicationController
  def index
    render json: CongressMember.bioguide_map
  end
end
