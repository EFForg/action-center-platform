Actioncenter::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true


  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp


  config.action_mailer.default_url_options = { :host => Rails.application.secrets.smtp_domain, :protocol => 'https' }
  config.action_mailer.asset_host = "https://#{Rails.application.secrets.smtp_domain}"

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_files = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = Rails.application.secrets.force_ssl.nil? ? true : Rails.application.secrets.force_ssl

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  config.logger = Logger.new STDOUT
  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store


  # Enables GZIP without nginx/apache

  #config.assets.initialize_on_precompile = true
  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )
  #config.assets.precompile += %w( welcome.css action_page.css admin/action_page.css )
  #config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  #config.assets.precompile += %w( .svg .eot .woff .ttf )

  # precompile stylesheets loaded by epiceditor iframes on admin pages
  config.assets.precompile += %w( EpicEditor/epiceditor/themes/base/epiceditor.css EpicEditor/epiceditor/themes/preview/github.css EpicEditor/epiceditor/themes/editor/epic-light.css)

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Enable basic auth if the secret is set to true.
  # At EFF we use this to prevent access to our Heroku staging access by setting the enable_basic_auth to 'true' and setting the basic_auth_username and basic_auth_password env variables.
  if Rails.application.secrets.enable_basic_auth == true
    config.middleware.use '::Rack::Auth::Basic' do |u, p|
      [u, p] == [Rails.application.secrets.basic_auth_username, Rails.application.secrets.basic_auth_password]
    end
  end

  # Rate limiting
  config.middleware.use Rack::Attack
end
