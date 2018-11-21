class Admin::UsersController < Admin::ApplicationController
  include DateRange

  def index
    respond_to do |format|
      format.json do
        if start_date == end_date
          @data = User.where('created_at BETWEEN ? AND ?', start_date, end_date + 1.day)
            .group_by_hour(:created_at, format: '%Y-%m-%d %H:%M:00 UTC').count
        else
          @data = User.where('created_at BETWEEN ? AND ?', start_date, end_date)
            .group_by_day(:created_at, format: '%Y-%m-%d 00:00:00 UTC').count
        end
        render json: @data
      end
      format.html do
        @users = filtered_users.order(created_at: :desc).paginate(page: params[:page])
      end
    end
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      flash[:notice] = "#{user.email} was updated"
    else
      flash[:error] = "Could not update #{user.email}"
    end

    redirect_to admin_users_path(params.permit(:query, :page).to_h.merge(anchor: "users"))
  end

  private

  def filtered_users
    if params[:query].present?
      User.where("LOWER(email) LIKE ? OR LOWER(first_name || ' ' || last_name) LIKE ?",
                 "%#{params[:query]}%", "%#{params[:query]}%")
    else
      User.all
    end
  end

  def user_params
    params.require(:user).permit(:collaborator)
  end
end
