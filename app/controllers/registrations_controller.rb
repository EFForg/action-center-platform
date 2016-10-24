class RegistrationsController < Devise::RegistrationsController
  after_filter :handle_nonunique_email, only: :create
  after_filter :set_create_notice, only: :create

  def update_resource(resource, params)
    super

    # For privacy, set an unconfirmed e-mail even if the supplied email is taken
    if resource.email_taken? and resource.user_facing_errors.empty?
      User.find(resource.id).update_attribute(:unconfirmed_email, account_update_params[:email])
      resource.unconfirmed_email = account_update_params[:email]
      flash[:notice] = I18n.t "devise.registrations.update_needs_confirmation"
    end

    resource
  end

  def after_update_path_for(resource)
    # Successful update path needs to match the failed update path so users can't tell
    # if e-mail validation failed.
    registration_path resource
  end

  def handle_nonunique_email
    if resource.email_taken? and resource.user_facing_errors.empty?
      user = User.where(:email => params[:user][:email]).first
      if user.confirmed?
        UserMailer.signup_attempt_with_existing_email(user).deliver_now
      else
        user.send_confirmation_instructions
      end
    end
  end

  def set_create_notice
    if resource.user_facing_errors.empty?
      cookies[:sweetAlert] = JSON.dump({title: "Thanks!", text: "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."})
      flash[:notice] = nil
    end
  end
end
