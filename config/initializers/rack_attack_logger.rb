ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
  if req.env['HTTP_X_FORWARDED_FOR']
    ip = req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
  else
    ip = req.ip
  end
  message = "Rate limit exceeded on #{req.fullpath}"
  Raven.capture_message(message, extra: { ip: ip })
end
