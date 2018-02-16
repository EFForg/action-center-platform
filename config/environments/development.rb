Actioncenter::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_deliveries = false
  config.action_mailer.delivery_method = :test

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.asset_host = 'http://localhost:3000'

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = Rails.application.secrets.force_ssl.nil? ? false : Rails.application.secrets.force_ssl


  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.assets.precompile = config.assets.precompile.map!{ |path| path == /(?:\/|\\|\A)application\.(css|js)$/ ? /(?<!jquery-sortable)(?:\/|\\|\A)application\.(css|js)$/ : path }
  config.assets.precompile += %w( admin/_bootstrap-theme.min.css admin/admin.css admin.js admin-head.js )

  # precompile stylesheets loaded by epiceditor iframes on admin pages
  #   config.assets.precompile += %w( EpicEditor/epiceditor/themes/base/epiceditor.css EpicEditor/epiceditor/themes/preview/github.css EpicEditor/epiceditor/themes/editor/epic-light.css)
  #

  unless Rails.application.secrets.sentry_dsn.nil?
    config.action_dispatch.show_exceptions = false
    config.consider_all_requests_local = false
  end

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  if config.esi_enabled
    # Expand <esi:include> tags in response
    require "esi_middleware"
    config.middleware.use "EsiMiddleware"
  end
end
