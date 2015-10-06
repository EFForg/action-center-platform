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

  def sanitize_filename(filename)
    # Split the name when finding a period which is preceded by some
    # character, and is followed by some character other than a period,
    # if there is no following period that is followed by something
    # other than a period (yeah, confusing, I know)
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

    # We now have one or two parts (depending on whether we could find
    # a suitable period). For each of these parts, replace any unwanted
    # sequence of characters with an underscore
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

    # Finally, join the parts with a period and return the result
    return fn.join '.'
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
