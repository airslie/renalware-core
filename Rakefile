# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

puts "Loading engine rake tasks"

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

# We can use rake tasks like app:db:reset when APP_RAKEFILE set
unless defined?(APP_RAKEFILE)
  APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
end

load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"

# Bundler::GemHelper.install_tasks

# assets:* tasks for For Heroku only
# When deploying the engine to Heroku, we are actually deploy the spec/dummy app.
# Heroku however loads this Rakefile first hunting for an assets:precompile task to indicate
# it should compile the assets. If not found it won't compile assets and we won't have any styling.
namespace :assets do
  desc "Clean any assets within dummy app"
  task :clean do
    Rake::Task["app:assets:clean"].invoke
  end

  desc "Precompile assets within dummy app"
  task :precompile do
    Rake::Task["app:yarn:install"].invoke
    Rake::Task["app:assets:precompile"].invoke
  end

  desc "Clobbers assets within dummy app"
  task :clobber do
    Rake::Task["app:assets:clobber"].invoke
  end
end

namespace :yarn do
  task :install do
    Rake::Task["app:yarn:install"].invoke
  end
end

# Default rake task to run all tests:
#   bundle exec rake
task :engine_default_task do
  sh "bin/rspec"
  sh "bin/cucumber"
  sh "bin/cucumber TEST_DEPTH=web --profile rake_web"
end
task(:default).clear.enhance(["engine_default_task"])
