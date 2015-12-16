class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :cors
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

  # This method seems to check if the request is coming from a domain listed in
  # `cors_allowed_domains` in application.yml, and if it is, the response gets
  # a header allowing the requesting domain to use this app's CRUD
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

  # header disables cache so backbutton post-logout reveals no email address
  def send_cache_disablement_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
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
