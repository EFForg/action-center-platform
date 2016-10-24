class RegistrationsController < Devise::RegistrationsController
  after_filter :set_create_notice, only: :create

  # POST /resource
  def create
    super do |resource|
      if resource.email_taken? and resource.user_facing_errors.empty?
        User.where(:email => params[:user][:email]).first.send_email_taken_notice
        set_create_notice
        respond_with resource, location: after_sign_up_path_for(resource)
        return
      end
    end
  end

  # PUT /resource
  def update
    super do |resource|
      if resource.email_taken? and resource.user_facing_errors.empty?
        User.where(:email => params[:user][:email]).first.send_email_taken_notice
        resource.update_attribute(:unconfirmed_email, account_update_params[:email])
        flash[:notice] = I18n.t "devise.registrations.update_needs_confirmation"
        respond_with resource, location: after_update_path_for(resource)
        return
      end
    end
  end

  def after_update_path_for(resource)
    registration_path resource
  end

  def set_create_notice
    if resource.user_facing_errors.empty?
      cookies[:sweetAlert] = JSON.dump({title: "Thanks!", text: "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."})
      flash[:notice] = nil
    end
  end
end
