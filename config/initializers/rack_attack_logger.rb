LOGGER = Logger.new("log/rack-attack.log")
ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
  message = "Rate limit exceeded on #{req.fullpath}"
  ip = req.ip || req.env['HTTP_X_FORWARDED_FOR'].ip.split(/\s*,\s*/)[0]
  LOGGER.info(message)
  Raven.capture_message(message, extra: { ip: ip })
end
