Sentry.init do |config|
  config.dsn = Rails.application.secrets.sentry_dsn
  # get breadcrumbs from logs
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # enable tracing
  # we recommend adjusting this value in production
  config.traces_sample_rate = 1.0
end
