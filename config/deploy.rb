# Automatically precompile assets
load "deploy/assets"

# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"

# RVM integration
require "rvm/capistrano"

# Name of the application in scm (GIT)
set :application, "eol-globi-web"
set :repository,  "git@github.com:reiz/eol-globi-web.git"

# Source Control Management
set :scm, :git

set :deploy_to, "/var/www/#{application}"

# server there the web server is running (nginx)
role :web, "46.4.36.142"

# server there the app server is running
role :app, "46.4.36.142"

# server there the db is running
# This is where Rails migrations will run
role :db,  "46.4.36.142", :primary => true

set :rails_env, :production

# user on the server
set :user, "capistrano"
set :use_sudo, false

# Target ruby version
set :rvm_ruby_string, '2.0.0'

# System-wide RVM installation
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

set :default_environment, {
  'RUBY_VERSION' => 'ruby-2.0.0-p0',
  'GEM_HOME'     => '/usr/local/rvm/gems/ruby-2.0.0-p0@eol-globi-web/',
  'GEM_PATH'     => '/usr/local/rvm/gems/ruby-2.0.0-p0@eol-globi-web/',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-2.0.0-p0@eol-globi-web/'
}

# Apply default RVM version for the current account
after "deploy:setup", "deploy:set_rvm_version"

namespace :deploy do

  task :set_rvm_version, :roles => :app, :except => { :no_release => true } do
    run "source /etc/profile.d/rvm.sh && rvm use #{rvm_ruby_string} --default"
  end

  task :start, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/puma start"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/puma stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/puma restart"
  end

  # Precompile assets
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
    end
  end

end
