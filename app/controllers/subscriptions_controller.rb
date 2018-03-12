require "civicrm"
class SubscriptionsController < ApplicationController
  # See https://github.com/EFForg/action-center-platform/wiki/Deployment-Notes#csrf-protection
  skip_before_filter :verify_authenticity_token

  def create
    email = params[:subscription][:email]
    if EmailValidator.valid?(email)
      params[:subscription][:opt_in] = params[:subscription][:opt_in] || false
      CiviCRM::subscribe params[:subscription]

      update_user_data(email: email)
      render json: {}
    else
      render text: "fail, bad email", status: 400
    end
  end
end
