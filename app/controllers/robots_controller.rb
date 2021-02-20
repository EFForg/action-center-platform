class RobotsController < ApplicationController
  def show
    if Rails.env.development? || (Rails.application.secrets.enable_basic_auth == "true")
      render body: "User-agent: *\nDisallow: /"
    else
      render body: ""
    end
  end

  # amazon hits this for monitoring.  This endpoint can potentially be useful
  # for load balancing/ database connection detecting
  def heartbeat
    if User.count >= 0
      render body: "Application Heart Beating OK"
    else
      render body: "There's something odd about the database, probably disconnected...", status: 500
    end
  end
end
