# This is an endpoint for the Amazon SES service to notify us when there are
# bounced emails.  The JSON expected in `index` is particular to Amazon's SNS
# notification service, and thus will not work for other services.
class BounceController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    begin
      success = true
      raise ActiveRecord::RecordNotFound unless params['amazon_authorize_key'] == Rails.application.secrets.amazon_authorize_key
      message = JSON.parse(request.body.read)['Message']
      bounce_arr = JSON.parse(message)["bounce"]["bouncedRecipients"]
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
