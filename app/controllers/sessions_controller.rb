class SessionsController < Devise::SessionsController
  after_filter :set_logged_in, only: :create
  before_filter :unset_logged_in, only: :destroy

  def set_logged_in
    if (user_signed_in?)
      # Sets a "permanent" cookie (which expires in 20 years from now).
      cookies.permanent[:logged_in] = "I <3 EFF"
    end
  end

  def unset_logged_in
    cookies.delete(:logged_in)
  end

  def destroy
    super
    flash.delete(:notice)
  end

  def create
    super do
      if current_user.password_expired?
        # thrust the user to a change password page....
        # Create a reset token
        # redirect to the reset page token... which can't be done because that
        # only goes through the mail...
        redirect_to "/sessions/password_reset"
      end
    end
  end

  def password_reset
    if user_signed_in?
      @user = current_user
    else
      # Should never end up here
      redirect_to "/", flash: { notice: "You need to be logged in to reset your password!" }
    end
  end
end
