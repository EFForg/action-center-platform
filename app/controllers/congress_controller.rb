
class CongressController < ApplicationController
  def index
    render json: Congress.bioguide_map
  end
end
