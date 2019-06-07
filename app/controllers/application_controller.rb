class ApplicationController < ActionController::Base
  include ApplicationHelper
  include RequestOriginValidation
  include LoggedInvisibleCaptcha

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :cors
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :user_conditional_logic

  skip_before_action :set_ahoy_cookies
  skip_before_action :track_ahoy_visit
  skip_before_action :set_ahoy_request_store

  def user_conditional_logic
    if user_signed_in?
      lock_users_with_expired_passwords! unless user_is_being_told_to_reset_pass_or_is_resetting_pass?
    end
  end

  # This method seems to check if the request is coming from a domain listed in
  # `cors_allowed_domains` in application.yml, and if it is, the response gets
  # a header allowing the requesting domain to use this app's CRUD
  def cors
    if Actioncenter::Application.config.cors_allowed_domains.include? request.env["HTTP_ORIGIN"] or Actioncenter::Application.config.cors_allowed_domains.include? "*"
      response.headers["Access-Control-Allow-Origin"] = request.env["HTTP_ORIGIN"]
    end
  end

  def self.manifest(value = nil)
    if value.nil?
      @manifest
    else
      @manifest = value
    end
  end

  def manifest
    self.class.manifest || "application"
  end

  # if the current_user's password is expired, force them to the reset page
  # or lock them out of secure areas
  def lock_users_with_expired_passwords!
    if current_user.password_expired?
      verifier = ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
      redirect_to sessions_password_reset_path(continue: verifier.generate(request.path))
    end
  end

  def user_is_being_told_to_reset_pass_or_is_resetting_pass?
    (params[:controller] == "sessions" && params[:action] == "password_reset") ||
      (params[:controller] == "registrations" && params[:action] == "update")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:record_activity, :subscribe])
  end

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end
end
