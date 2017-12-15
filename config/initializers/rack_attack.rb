class Rack::Attack
  throttle('registrations', limit: 10, period: 1.day) do |req|
    if req.path == '/' && req.post?
      return req.ip || req.env['HTTP_X_FORWARDED_FOR'].ip.split(/\s*,\s*/)[0]
    end
  end

  throttle('password reset', limit: 1, period: 1.day) do |req|
    if req.path == '/password' && req.params['user']
      req.params['user']['email'].presence
    end
  end
end
