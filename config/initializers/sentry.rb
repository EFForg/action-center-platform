# frozen_string_literal: true

require "active_support/parameter_filter"

# https://docs.sentry.io/platforms/ruby/configuration/options/
Sentry.init do |config|
  config.dsn = Rails.application.secrets.sentry_dsn
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  config.environment = ENV['SENTRY_ENVIRONMENT']

  config.send_default_pii = false

  config.before_breadcrumb = lambda do |breadcrumb, hint|
    # # Remove query params from path in request breadcrumbs, since they can share sensitive info like addresses
    if breadcrumb.category =~ /\.action_controller/
      breadcrumb.data[:path] = begin
        url = URI.parse(breadcrumb.data[:path])
        url.query = nil
        url.to_s
      rescue URI::Error
        breadcrumb.data[:path].split("?").first
      end
    end
    breadcrumb
  end

  # https://docs.sentry.io/platforms/ruby/configuration/sampling/
  # A sample rate of 0 or false sends nothing, 1.0 or true sends everything
  config.traces_sampler = lambda do |sampling_context|
    # if this is the continuation of a trace, just use that decision (rate controlled by the caller)
    unless sampling_context[:parent_sampled].nil?
      next sampling_context[:parent_sampled]
    end

    # /heartbeat
    if sampling_context.dig(:env, 'HTTP_USER_AGENT') =~ (/healthcheck/i) || sampling_context.dig(:env, 'PATH_INFO') =~ (/heartbeat/i)
      0.0
    else
      begin ENV['SENTRY_TRACES_SAMPLE_RATE'].to_f rescue 0.0 end
    end
  end

  # Set profiles_sample_rate to profile 100% of sampled transactions.
  # We recommend adjusting this value in production.
  #
  # Does not send profiling info if set to 0
  config.profiles_sample_rate = begin ENV['SENTRY_PROFILES_SAMPLE_RATE'].to_f rescue 0 end
end
