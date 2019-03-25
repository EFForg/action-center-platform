require "civicrm"
class SubscriptionsController < ApplicationController
  # See https://github.com/EFForg/action-center-platform/wiki/Deployment-Notes#csrf-protection
  skip_before_action :verify_authenticity_token, only: :create
  before_action :verify_request_origin, only: :create

  invisible_captcha only: :create
  before_action :authenticate_user!, only: :edit

  def create
    email = params[:subscription][:email]
    if !EmailValidator.valid?(email)
      render json: { message: "Bad news, something went wrong with your email address. Please check it for typos and try again." }, status: 400
      return
    end

    update_user_data(email: email)
    params[:subscription][:opt_in] = params[:subscription][:opt_in] || false
    subscription = CiviCRM::subscribe params[:subscription]
    if subscription["error"]
      render json: { message: subscription["error_message"] }, status: 500
    else
      render json: {}
    end
  end

  def edit
    civicrm_url = current_user.manage_subscription_url!
    if civicrm_url
      redirect_to civicrm_url
    else
      flash.now[:error] = I18n.t "subscriptions.edit_error"
      redirect_to "/account"
    end
  end
end
