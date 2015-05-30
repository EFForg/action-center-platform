require 'civicrm'
class SubscriptionsController < ApplicationController
  def create
    params[:subscription][:opt_in] = false
    CiviCRM::subscribe params[:subscription]

    email = params[:subscription][:email]
    update_user_data(email: email)

    respond_to do |format|
      format.json { render json: {} }
      format.html { redirect_to welcome_index_path }
    end
  end
end
