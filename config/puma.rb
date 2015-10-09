environment ENV.fetch('RAILS_ENV', 'development')

daemonize true

pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

workers 2

threads 10, 20

worker_timeout 60

app_path = File.expand_path('../..', __FILE__)
bind "unix:///#{app_path}/tmp/sockets/massage_app_puma.sock"

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

preload_app!

stdout_redirect 'log/puma.log', 'log/puma.log', true
