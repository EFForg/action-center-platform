# These endpoints allow the Amazon SES service to notify us when there are bounced
# emails or complaints (ex we are marked as spam). The expected JSON is particular to
# Amazon's SNS notification service, and thus will not work for other services.
class SnsController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :verify_amazon_authorize_key

  def bounce
    begin
      success = true
      message = JSON.parse(request.body.read)['Message']
      bounce_arr = JSON.parse(message)['bounce']['bouncedRecipients']
      bounce_arr.each do |recipient|
        Bounce.create(email: recipient['emailAddress'].downcase)
      end
    rescue
      success = false
    ensure
      render json: {success: success}
    end
  end

  def complaint
    logger.info 'Received Amazon SES complaint notification'
    begin
      success = true
      message = JSON.parse(request.body.read)['Message']
      complaint = JSON.parse(message)['complaint']
      if complaint.nil?
        # Save non-standard requests, ex subscription confirmation
        Complaint.create(body: message)
        raise 'Unexpected SNS request format'
      end
      recipients = complaint['complainedRecipients']
      recipients.each do |recipient|
        Complaint.create(email: recipient['emailAddress'].downcase,
                         user_agent: complaint['userAgent'],
                         feedback_type: complaint['complaintFeedbackType'],
                         body: message)
      end
   rescue
     success = false
   ensure
      render json: {success: success}
    end
  end

  private

  def verify_amazon_authorize_key
    raise ActiveRecord::RecordNotFound unless params['amazon_authorize_key'] == Rails.application.secrets.amazon_authorize_key
  end
end
