unless ENV['HOST_IP'].nil?
  BetterErrors::Middleware.allow_ip! ENV['HOST_IP']
end
