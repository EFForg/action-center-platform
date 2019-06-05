class RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: :create
  after_action :set_create_notice, only: :create

  # POST /resource
  def create
    super do |resource|
      handle_nonunique_email if resource.email_taken?
      return if performed?
    end
  end

  # PUT /resource
  def update
    super do |resource|
      handle_nonunique_email if resource.email_taken?
      return if performed?
    end
  end

  private

  def handle_nonunique_email
    resource.errors.delete(:email)

    if resource.errors.empty?
      existing = User.find_by_email(resource.email)
      existing.send_email_taken_notice

      # Allow unconfirmed users to set a new password by re-registering.
      if !existing.confirmed?
        existing.update_attributes(sign_up_params)
      end

      if resource.persisted?
        resource.update_attribute(:unconfirmed_email, account_update_params[:email])
        flash[:notice] = I18n.t "devise.registrations.update_needs_confirmation"
        respond_with resource, location: after_update_path_for(resource)
      else
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    end
  end

  def after_update_path_for(resource)
    if params[:continue].present?
      verifier = ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
      verifier.verify(params[:continue])
    else
      edit_registration_path(resource)
    end
  end

  def set_create_notice
    if resource.errors.empty?
      cookies[:sweetAlert] = JSON.dump({ title: "Thanks!", text: "A message with a confirmation link has been sent to your email address. Please open the link to activate your account." })
      flash[:notice] = nil
    end
  end
end
