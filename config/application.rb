require File.expand_path("../boot", __FILE__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
module Actioncenter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += %W(#{config.root}/lib)
    config.eager_load_paths += %W(#{config.root}/lib)
    config.assets.paths << Rails.root.join('node_modules')

    #config.logger = ActiveSupport::Logger.new(STDOUT)
    config.to_prepare do
          Devise::Mailer.layout "email" # email.haml or email.erb
    end

    config.exceptions_app = ->(env) { ExceptionsController.action(:show).call(env) }

    config.action_mailer.smtp_settings = {
      address: Rails.application.secrets.smtp_address,
      port: Rails.application.secrets.smtp_port,
      domain: Rails.application.secrets.smtp_domain,
      authentication: Rails.application.secrets.smtp_authentication,
      enable_starttls_auto: Rails.application.secrets.smtp_enable_starttls_auto,
      user_name: Rails.application.secrets.smtp_username,
      password: Rails.application.secrets.smtp_password
    }
    config.action_mailer.default_options = {
      from: Rails.application.secrets.mailings_from
    }

    config.cors_allowed_domains = Rails.application.secrets.cors_allowed_domains ? Rails.application.secrets.cors_allowed_domains.split(" ") : []

    config.twitter_handle = Rails.application.secrets.twitter_handle
    config.twitter_related = Rails.application.secrets.twitter_related ? Rails.application.secrets.twitter_related.split(" ") : []
    config.facebook_handle = Rails.application.secrets.facebook_handle
    config.call_tool_url = Rails.application.secrets.call_tool_url
    config.congress_forms_url = Rails.application.secrets.congress_forms_url
    config.time_zone = Rails.application.secrets.time_zone || "Eastern Time (US & Canada)"
    config.active_record.raise_in_transactional_callbacks = true

    # fix file attachment:
    # https://github.com/EFForg/action-center-platform/pull/408#issuecomment-381269915
    # https://stackoverflow.com/questions/49176124/error-no-handler-found-with-base64-for-paperclip-5-2
    Paperclip::HttpUrlProxyAdapter.register
  end
end
