module LoggedInvisibleCaptcha
  extend ActiveSupport::Concern

  def on_spam(options = {})
    log_failure
    super
  end

  def on_timestamp_spam(options = {})
    log_failure
    super
  end

  def log_failure
    Sentry.capture_message("A suspected automated form fill was rejected", level: :info)
  end
end
