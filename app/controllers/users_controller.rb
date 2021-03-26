class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @actionPages = ActionPage.order("id desc")
    @actions_taken = current_user.events.actions.map { |i| i["properties"]["actionPageId"].to_i }
  end

  def update
    flash[:notice] = if current_user.update(user_params)
                       "You updated your account successfully."
                     else
                       "Could not update your account."
                     end

    if request.xhr?
      render json: {}, status: 200
    else
      redirect_to user_path
    end
  end

  def clear_activity
    # rubocop:todo Rails/SkipsModelValidations
    current_user.events.update_all(user_id: nil)
    # rubocop:enable Rails/SkipsModelValidations
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
