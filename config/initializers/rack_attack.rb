class Rack::Attack
  safelist('eff office') do |req|
    if req.env['HTTP_X_FORWARDED_FOR']
      ip = req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
    else
      ip = req.ip
    end

    Array(ENV["unthrottled_ips"].try(:split, ",")).include?(ip)
  end

  throttle('registrations', limit: 10, period: 1.day) do |req|
    original_user(req) if req.path == '/' && req.post?
  end

  throttle('subscriptions', limit: 10, period: 1.day) do |req|
    original_user(req) if req.path == '/subscriptions' && req.post?
  end

  throttle('password reset', limit: 10, period: 1.day) do |req|
    if req.path == '/password' && req.params['user']
      # Normalize email address (as Devise does by default).
      req.params['user']['email'].presence ? req.params['user']['email'].strip.downcase : nil
    end
  end

  throttle('petition signatures', limit: 50, period: 1.day) do |req|
    original_user(req) if req.path == '/tools/petition' && req.post?
  end

  throttle('calls', limit: 3, period: 1.day) do |req|
    req.params['phone'] if req.path == '/tools/call' && req.post?
  end

  private

  def self.original_user(req)
    # On Production, we route all traffic through Fastly.
    # Check the HTTP_X_FORWARDED_FOR header to get the originating IP.
    if req.env['HTTP_X_FORWARDED_FOR']
      req.env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]
    else
      req.ip
    end
  end
end
