require "civicrm"
class SubscriptionsController < ApplicationController
  # See https://github.com/EFForg/action-center-platform/wiki/Deployment-Notes#csrf-protection
  skip_before_filter :verify_authenticity_token, only: :create
  before_filter :verify_request_origin, only: :create

  before_filter :authenticate_user!, only: :edit

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

  def edit
    civicrm_url = current_user.manage_subscription_url!
    if civicrm_url
      redirect_to civicrm_url
    else
      flash.now[:error] = "We're unable to generate a subscription management URL. Please try again later."
      redirect_to "/account"
    end
  end
end
