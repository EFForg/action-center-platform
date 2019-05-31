module LoggedInvisibleCaptcha
  extend ActiveSupport::Concern

  module ClassMethods
    def logged_invisible_captcha(options = {})
      options[:on_spam] = :logged_on_spam
      options[:on_timestamp_spam] = :logged_on_timestamp_spam
      invisible_captcha options
    end
  end

  def logged_on_spam
    log_failure
    on_spam
  end

  def logged_on_timestamp_spam
    log_failure
    on_timestamp_spam
  end

  def log_failure
    Raven.capture_message("A suspected automated form fill was rejected",
                          level: :info)
  end
end
