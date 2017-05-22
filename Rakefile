# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# require File.expand_path("../config/application", __FILE__)

# Rails.application.load_tasks
p "Loading engine rake tasks"

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

# We can use rake tasks like app:db:reset when APP_RAKEFILE set
unless defined?(APP_RAKEFILE)
  p "Defining APP_RAKEFILE in the engine"
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

Bundler::GemHelper.install_tasks
