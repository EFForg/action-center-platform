class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    send_cache_disablement_headers

    @actionPages = ActionPage.order('id desc')
    @user_action_counts = Rails.cache.fetch('user_action_counts', :expires_in => 24.hours) {
      User.select( "users.id, count(ahoy_events.id) AS events_count" )
        .joins( "LEFT OUTER JOIN ahoy_events ON ahoy_events.user_id = users.id" )
        .where( "ahoy_events.name IS null OR ahoy_events.name = ?", "Action" )
        .group( "users.id" )
        .map { |u| u.events_count }
    }

    user_count = current_user.events.actions.count
    @percentile = @user_action_counts.percentile_rank(user_count-1).round(0).ordinalize

    @actions_taken = current_user.events.actions.map {|i| i['properties']['actionPageId'].to_i}
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
    params.require(:user).permit(:first_name, :last_name, :street_address,
                                 :city, :state, :country_code, :zipcode,
                                 :phone, :record_activity)
  end

end
