class Rack::Attack
  throttle('registrations', limit: 10, period: 1.day) do |req|
    if req.path == '/' && req.post?
      req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
    end
  end

  # this didn't interact well with redirects
  # throttle('everything', limit: 50, period: 1.day) do |req|
  #   req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
  # end

  blocklist("security probes") do |req|
    ip = req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
    ["111.125.208.206"].include?(ip)
  end

  ### Custom Throttle Response ###

  self.throttled_response = lambda do |env|
    ip = env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
#    Raven.capture_message("registration rate limit exceeded", extra: { ip: ip })
    [ 302, { "Location" => "/register" }, [''] ]
  end
end
