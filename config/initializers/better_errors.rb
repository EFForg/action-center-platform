if defined?(BetterErrors) and ENV['HOST_IP']
  BetterErrors::Middleware.allow_ip! ENV['HOST_IP']
end