class Rack::Attack
  throttle('registrations', limit: 10, period: 1.day) do |req|
    original_user if req.path == '/' && req.post?
  end

  throttle('password reset', limit: 10, period: 1.day) do |req|
    if req.path == '/password' && req.params['user']
      req.params['user']['email'].presence
    end
  end

  throttle('petition signatures', limit: 50, period: 1.day) do |req|
    original_user if req.path == '/tools/petition' && req.post?
  end

  private

  def original_user
    # On Production, we route all traffic through Fastly.
    # Check the HTTP_X_FORWARDED_FOR header to get the originating IP.
    if req.env['HTTP_X_FORWARDED_FOR']
      req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
    else
      req.ip
    end
  end
end
