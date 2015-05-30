# If you have a very small app you may be able to
# increase this, but in general 3 workers seems to
# work best
worker_processes 3

# Load your app into the master before forking
# workers for super-fast worker spawn times
preload_app true

# http://unicorn.bogomips.org/Unicorn/Configurator.html#preload_app-method
#before_fork do |server, worker|
#  if defined?(ActiveRecord::Base)
#    ActiveRecord::Base.connection.disconnect!
#  end
#end
#after_fork do |server, worker|
#  if defined?(ActiveRecord::Base)
#    ActiveRecord::Base.establish_connection
#  end
#end

# Immediately restart any workers that
# haven't responded within 30 seconds
timeout 30
