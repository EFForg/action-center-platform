class RobotsController < ApplicationController
  def show
    if Rails.env.development? or Rails.application.secrets.enable_basic_auth == "true"
      render text: "User-agent: *\nDisallow: /"
    else
      render text: ""
    end
  end

  # amazon hits this for monitoring.  This endpoint can potentially be useful
  # for load balancing/ database connection detecting
  def heartbeat
    if User.count >= 0
      render text: "Application Heart Beating OK"
    else
      render text: "There's something odd about the database, probably disconnected...", status: 500
    end
  end
end
