class BounceController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    begin
      success = true
      raise ActiveRecord::RecordNotFound unless params['amazon_authorize_key'] == Rails.application.secrets.amazon_authorize_key
      bounce_arr = JSON.parse(request.body.read)["bounce"]["bouncedRecipients"]
      bounce_arr.each do |recipient|
        Bounce.create(email: recipient['emailAddress'].downcase)
      end
    rescue
      success = false
    ensure
      render json: {success: success}
    end
  end
end
