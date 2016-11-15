class Admin::UsersController < Admin::ApplicationController
  def index
    @users = filtered_users.order(created_at: :desc).paginate(page: params[:page])
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
