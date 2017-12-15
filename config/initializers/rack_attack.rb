class Rack::Attack
  throttle('registrations', limit: 10, period: 1.day) do |req|
    if req.path == '/' && req.post?
      req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
    end
  end

  throttle('password reset', limit: 10, period: 1.day) do |req|
    if req.path == '/password'
      req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
    end
  end

  ### Custom Throttle Response ###

  self.throttled_response = lambda do |env|
    ip = env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
#    Raven.capture_message("registration rate limit exceeded", extra: { ip: ip })
    [ 302, { "Location" => "/register" }, [''] ]
  end
end
