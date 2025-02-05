Sentry.init do |config|
  config.dsn = Rails.application.secrets.sentry_dsn
end
