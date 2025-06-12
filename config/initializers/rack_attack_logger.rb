ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
  if req.env['HTTP_X_FORWARDED_FOR']
    ip = req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
  else
    ip = req.ip
  end
  message = "Rate limit exceeded on #{URI(req.fullpath).path}" # Drop query params, which may be sensitive
  Sentry.capture_message(message, extra: { ip: ip })
end
