require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Actioncenter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0


    config.assets.paths << Rails.root.join('node_modules')

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

    config.active_record.belongs_to_required_by_default = false
    #  config.active_support.cache_format_version = 7.0

    config.cors_allowed_domains = Rails.application.secrets.cors_allowed_domains ? Rails.application.secrets.cors_allowed_domains.split(" ") : []

    config.twitter_handle = Rails.application.secrets.twitter_handle
    config.twitter_related = Rails.application.secrets.twitter_related ? Rails.application.secrets.twitter_related.split(" ") : []
    config.facebook_handle = Rails.application.secrets.facebook_handle
    config.call_tool_url = Rails.application.secrets.call_tool_url
    config.congress_forms_url = Rails.application.secrets.congress_forms_url
    config.google_civic_api_url = Rails.application.secrets.google_civic_api_url
    config.time_zone = Rails.application.secrets.time_zone || "Eastern Time (US & Canada)"

  end
end
