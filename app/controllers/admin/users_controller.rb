class Admin::UsersController < Admin::ApplicationController
  include DateRange

  def index
    respond_to do |format|
      format.json do
        render json: User.group_created_in_range(start_date, end_date)
      end
      format.html do
        @add_or_remove_params = params.permit(:query, :page).to_h
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
      User.where("LOWER(email) LIKE %?% OR LOWER(first_name || ' ' || last_name) LIKE %?%",
                 params[:query], params[:query])
    else
      User.all
    end
  end

  def user_params
    params.require(:user).permit(:collaborator)
  end
end
