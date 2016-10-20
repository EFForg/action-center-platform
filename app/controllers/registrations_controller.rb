class RegistrationsController < Devise::RegistrationsController
  after_filter :set_create_notice, only: :create
  after_filter :send_password_reset_email, only: :create

  def send_password_reset_email
    user = User.where(:email => params[:user][:email]).first
    if user and user.confirmed?
      UserMailer.signup_attempt_with_existing_email(user).deliver_now
    end
  end

  def set_create_notice
    cookies[:sweetAlert] = JSON.dump({title: "Thanks!", text: "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."})
    flash[:notice] = nil
  end
end
