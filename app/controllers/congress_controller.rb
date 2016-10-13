
class CongressController < ApplicationController
  def index
    render json: Congress::Member.bioguide_map
  end
end
