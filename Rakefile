# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# require File.expand_path("../config/application", __FILE__)

# Rails.application.load_tasks
puts "Loading engine rake tasks"

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

# We can use rake tasks like app:db:reset when APP_RAKEFILE set
unless defined?(APP_RAKEFILE)
  APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
end
load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"
# require 'rake/testtask'

# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib'
#   t.libs << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = false
# end

# task default: :test

# assets:precompile task for For Heroku only
# When deploying the engine to Heroku, we are actually deployment the spec/dummy app.
# Heroku however loads this Rakefile first hunting for an assets:precompile task to indicate
# it should compile the assets. If not found it won't compile assets and we won't have any styling.
namespace :assets do
  desc 'Clean any assets within dummy app'
  task :clean do
    Dir.chdir('spec/dummy') do
      system('bundle exec rake assets:clean')
    end
  end

  desc 'Precompile assets within dummy app'
  task :precompile do
    Dir.chdir('spec/dummy') do
      system('bundle exec rake assets:precompile')
    end
  end
end

Bundler::GemHelper.install_tasks
