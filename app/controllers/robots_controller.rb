class RobotsController < ApplicationController
  def show
    if Rails.env.development? or Rails.application.secrets.enable_basic_auth == 'true'
      render text: "User-agent: *\nDisallow: /"
    else
      render text: ""
    end
  end
end
