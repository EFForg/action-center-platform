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
end
