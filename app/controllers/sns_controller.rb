# These endpoints allow the Amazon SES service to notify us when there are bounced
# emails or complaints (ex we are marked as spam). The expected JSON is particular to
# Amazon's SNS notification service, and thus will not work for other services.
class SnsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :verify_amazon_authorize_key
  before_action :set_context, :log_request

  def bounce
    message = set_message
    recipients = message["bounce"]["bouncedRecipients"]
    recipients.each do |recipient|
      Bounce.create(email: recipient["emailAddress"].downcase)
    end
    render json: { success: true }
  end

  def complaint
    message = set_message
    recipients = message["complaint"]["complainedRecipients"]
    recipients.each do |recipient|
      Complaint.create(email: recipient["emailAddress"].downcase,
                       user_agent: message["complaint"]["userAgent"],
                       feedback_type: message["complaint"]["complaintFeedbackType"],
                       body: message)
    end
    render json: { success: true }
  end

  private

  def verify_amazon_authorize_key
    raise ActiveRecord::RecordNotFound unless params["amazon_authorize_key"] == Rails.application.secrets.amazon_authorize_key
  end

  def set_context
    Raven.extra_context(message: request.body.read)
    request.body.rewind
  end

  def set_message
    body = JSON.parse(request.body.read)
    return JSON.parse(body["Message"])
  end

  def log_request
    logger.info "Received Amazon SES #{action_name} notification"
    Raven.capture_message("Received Amazon SES #{action_name} notification", level: "info")
  end
end
