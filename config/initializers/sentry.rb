# frozen_string_literal: true

require "active_support/parameter_filter"

# https://docs.sentry.io/platforms/ruby/configuration/options/
Sentry.init do |config|
  config.dsn = Rails.application.secrets.sentry_dsn
  # get breadcrumbs from logs
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  config.environment = ENV['SENTRY_ENVIRONMENT']

  config.send_default_pii = false

  config.before_breadcrumb = lambda do |breadcrumb, hint|
    # Remove query params from path in request breadcrumbs, since they can share sensitive info like addresses
    if hint.dig('request').present?
      breadcrumb.path = begin
        url = URI.parse(breadcrumb.path)
        url.query = nil
        url.to_s
      rescue URI::Error
        url.split("?").first
      end
    end
    breadcrumb
  end

  # Filter out potentially sensitive data before sending to Sentry.io
  # This applies any filters we've set to logs to also apply to Sentry data
  #
  # https://docs.sentry.io/platforms/ruby/guides/rails/configuration/filtering/
  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda do |event, _hint|
    # Sanitize extra data
    if event.extra
      event.extra = filter.filter(event.extra)
    end
    # Sanitize user data
    if event.user
      event.user = filter.filter(event.user)
    end
    # Sanitize context data (if present)
    if event.contexts
      event.contexts = filter.filter(event.contexts)
    end

    # Return the sanitized event object
    event
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
