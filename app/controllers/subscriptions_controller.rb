require 'civicrm'
class SubscriptionsController < ApplicationController
  def create
    email = params[:subscription][:email]
    if EmailValidator.valid?(email)
      params[:subscription][:opt_in] = false
      CiviCRM::subscribe params[:subscription] unless Rails.env == 'test'

      update_user_data(email: email)
      render json: {}
    else
      render text: "fail, bad email", status: 400
    end
  end
end
