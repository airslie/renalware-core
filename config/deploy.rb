# Config valid only for current version of Capistrano
lock "3.8.1"

set :application, "renalware"
set :repo_url, "git@github.com:airslie/renalwarev2.git"
# TODO: change to master
set :branch, "chore/capistrano_and_vagrant"
# set :deploy_to, "/var/www/renalware"

# Default value for :pty is false
# set :pty, true

append :stages, %w(vagrant)

# Default value for :linked_files is []
# append :linked_files, "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs,
       "log",
       "tmp/pids",
       "tmp/cache",
       "tmp/sockets",
       "vendor/bundle",
       "public/system"

# Config files and symlinks
set :config_files, %w(nginx.conf)
set :symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:application)}"
  }
]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
