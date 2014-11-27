source "https://rubygems.org"
ruby "2.1.3"

gem "rails", "~> 4.1"
gem "mysql2"
gem "foundation-rails"
gem "jquery-rails"
gem "underscore-rails"
gem "uglifier", ">= 1.3.0"
gem "sass-rails", "~> 4.0.3"
gem "haml-rails"
gem "sdoc", "~> 0.4.0", group: :doc
gem "elasticsearch-model"
gem "elasticsearch-rails"

group :development, :test do
  gem 'poltergeist'
  gem "frog_spawn", :git => "git@github.com:dmgarland/frog_spawn.git"
  # gem "frog_spawn", :path => '/home/daniel/projects/frog_spawn'
  gem "spring"
  gem "cucumber-rails", :require => false
  gem "rspec-rails"
  gem "rspec-expectations"
  gem "capybara", "2.1.0"
  gem "capybara-webkit"
  gem "launchy"
  gem "pry"
  gem "database_cleaner"
  gem "spring-commands-cucumber"
  gem "spring-commands-rspec"
  gem "ffaker"
end

group :production do
  gem "rails_12factor"
  gem "unicorn"
end