class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :cors
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

  def cors
    if Actioncenter::Application.config.cors_allowed_domains.include? request.env['HTTP_ORIGIN'] or Actioncenter::Application.config.cors_allowed_domains.include? "*"
      response.headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
    end
  end

  def self.manifest(value=nil)
    if value.nil?
      @manifest
    else
      @manifest = value
    end
  end

  def manifest
    self.class.manifest || 'application'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :record_activity
    devise_parameter_sanitizer.for(:sign_up) << :subscribe
  end

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end
end
