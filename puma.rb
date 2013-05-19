environment "production"
pidfile "./tmp/puma/pid"
state_path "./tmp/puma/state"
bind "unix://./tmp/puma/puma.sock"
