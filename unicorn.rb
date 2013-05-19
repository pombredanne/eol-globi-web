# Ensure that we're running in the production environment
rails_env = ENV['RAILS_ENV'] || 'production'

# User to run under
user 'capistrano', 'capistrano'

# We will spawn off two worker processes and one master process
worker_processes 20

# set the default working directory
working_directory "/var/www/eol-globi-web/current"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 30

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
# listen "/var/www/eol-globi-web/shared/sockets/unicorn.sock", :backlog => 64

pid "/var/www/eol-globi-web/shared/pids/unicorn.pid"

# Set the path of the log files
stderr_path "/var/www/eol-globi-web/current/log/unicorn.stderr.log"
stdout_path "/var/www/eol-globi-web/current/log/unicorn.stdout.log"
