class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @actionPages = ActionPage.order("id desc")
    @actions_taken = current_user.events.actions.map { |i| i["properties"]["actionPageId"].to_i }
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = "You updated your account successfully."
    else
      flash[:notice] = "Could not update your account."
    end

    if request.xhr?
      render json: {}, status: 200
    else
      redirect_to user_path
    end
  end

  def clear_activity
    current_user.events.update_all(user_id: nil)
    redirect_to user_path
  end

  protected

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :street_address, :city, :state,
      :country_code, :zipcode, :phone, :record_activity
    )
  end
end
