module LoggedInvisibleCaptcha
  extend ActiveSupport::Concern

  def on_spam(options = {})
    log_failure
    super options
  end

  def on_timestamp_spam(options = {})
    log_failure
    super options
  end

  def log_failure
    Raven.capture_message("A suspected automated form fill was rejected",
                          level: :info)
  end
end
